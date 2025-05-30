import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:autoexplorer/repositories/storage/abstract_storage_repository.dart';
import 'package:autoexplorer/repositories/storage/models/file_json.dart';
import 'package:autoexplorer/repositories/storage/storage_repository.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class ConnectivityService extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  late final StreamSubscription<List<ConnectivityResult>> _subscription;

  bool _hasInternet = false;
  bool get hasInternet => _hasInternet;

  ConnectivityService() {
    _subscription =
        _connectivity.onConnectivityChanged.listen(_updateConnection);
    _connectivity.checkConnectivity().then(_updateConnection);
  }

  /// Главный апдейт при смене состояния сети
  Future<void> _updateConnection(List<ConnectivityResult> results) async {
    final wasOnline = _hasInternet;

    if (results.contains(ConnectivityResult.none)) {
      _hasInternet = false;
    } else {
      _hasInternet = await InternetConnectionChecker().hasConnection;
    }

    // если изменилось состояние
    if (wasOnline != _hasInternet) {
      notifyListeners();

      // если только что восстановили интернет — запускаем _syncLog()
      if (!wasOnline && _hasInternet) {
        await _syncLog();
      }
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  /// Получает handle на createLog.json в базовой папке приложения
  Future<File> _getLogFile() async {
    final baseDir = await getApplicationDocumentsDirectory();
    final logFile = File(p.join(baseDir.path, 'createLog.json'));
    if (!await logFile.exists()) {
      await logFile.create(recursive: true);
      await logFile.writeAsString('[]', flush: true);
    }
    return logFile;
  }

  /// Пробегаем по всем записям из JSON-лога,
  /// отправляем каждую на Яндекс.Диск и удаляем из лога при успехе.
  Future<void> _syncLog() async {
    final logFile = await _getLogFile();
    final content = await logFile.readAsString();
    final List<dynamic> array = jsonDecode(content);

    if (array.isEmpty) return;

    final localRepo =
        GetIt.I<AbstractStorageRepository>(instanceName: 'local_repository');
    final yandexRepo =
        GetIt.I<AbstractStorageRepository>(instanceName: 'yandex_repository')
            as StorageRepository;

    final appDir = await localRepo.getAppDirectory(path: '/');

    for (final raw in List<dynamic>.from(array)) {
      final entry = FileJSON.fromJson(raw as Map<String, dynamic>);
      try {
        if (entry.type == 'file') {
          await yandexRepo.uploadFile(
            filePath: entry.uploadPath,
            uploadPath: entry.remotePath,
          );
        } else {
          await yandexRepo.createFolder(
            name: entry.uploadPath,
            path: entry.remotePath,
          );
        }

        // Успешно обработали запись — убираем из лога
        array.remove(raw);
        await logFile.writeAsString(jsonEncode(array), flush: true);
      } catch (e) {
        // на неудачу не реагируем, оставляем запись
        continue;
      }
    }
  }
}
