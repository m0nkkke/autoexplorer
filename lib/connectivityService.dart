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

// class ConnectivityService extends ChangeNotifier {
//   final Connectivity _connectivity = Connectivity();
//   // теперь StreamSubscription<List<ConnectivityResult>>
//   late final StreamSubscription<List<ConnectivityResult>> _subscription;

//   bool _hasInternet = false;
//   bool get hasInternet => _hasInternet;

//   ConnectivityService() {
//     // при любом изменении списка сетей будем вызывать _updateConnection
//     _subscription =
//         _connectivity.onConnectivityChanged.listen(_updateConnection);
//     // и сразу проверить текущее состояние
//     _connectivity.checkConnectivity().then(_updateConnection);
//   }

//   Future<void> _updateConnection(List<ConnectivityResult> results) async {
//     final wasOnline = _hasInternet;

//     // если в списке нет ничего, кроме none — сразу офлайн
//     if (results.contains(ConnectivityResult.none)) {
//       _hasInternet = false;
//     } else {
//       // проверяем реальный доступ в интернет
//       _hasInternet = await InternetConnectionChecker().hasConnection;
//     }

//     if (wasOnline != _hasInternet) {
//       notifyListeners();
//     }
//   }

//   @override
//   void dispose() {
//     _subscription.cancel();
//     super.dispose();
//   }
// }
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
        print("================");
        print("подключили интернет");
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
    print("================");
    print("метод _syncLog");
    final logFile = await _getLogFile();
    final content = await logFile.readAsString();
    final List<dynamic> array = jsonDecode(content);

    if (array.isEmpty) return;

    // Получаем репозитории через GetIt
    final localRepo =
        GetIt.I<AbstractStorageRepository>(instanceName: 'local_repository');
    final yandexRepo =
        GetIt.I<AbstractStorageRepository>(instanceName: 'yandex_repository')
            as StorageRepository;

    // Корневая папка applicationData
    final appDir = await localRepo.getAppDirectory(path: '/');

    // Итерируем поверх копии, чтобы удалять элементы из оригинального списка
    for (final raw in List<dynamic>.from(array)) {
      final entry = FileJSON.fromJson(raw as Map<String, dynamic>);
      try {
        if (entry.type == 'file') {
          print("================");
          print("file");
          // собираем полный локальный путь к файлу
          // final localPath = p.join(appDir.path, entry.uploadPath);
          await yandexRepo.uploadFile(
            filePath: entry.uploadPath,
            uploadPath: entry.remotePath,
          );
        } else {
          // для папки: имя и родительская директория
          // final name = p.basename(entry.remotePath);
          // final parent = p.dirname(entry.remotePath);
          print("================");
          print("folder");
          await yandexRepo.createFolder(
            name: entry.uploadPath,
            path: entry.remotePath,
            // path: parent == '.' ? '/' : parent,
          );
        }

        // при успехе — удаляем из списка и перезаписываем файл
        array.remove(raw);
        await logFile.writeAsString(jsonEncode(array), flush: true);
      } catch (e) {
        // если конкретная запись не ушла — пропускаем её,
        // дальше будут другие, и при повторном восстановлении сети
        // этот же код попробует ещё раз.
        continue;
      }
    }
  }
}
