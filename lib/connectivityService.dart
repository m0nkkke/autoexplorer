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

  // Стрим для уведомления о появлении интернета
  final _internetAvailableController = StreamController<bool>.broadcast();
  Stream<bool> get internetAvailableStream =>
      _internetAvailableController.stream;

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

      // Если интернет появился, уведомляем об этом
      if (!wasOnline && _hasInternet) {
        _internetAvailableController.add(true);
      }
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    _internetAvailableController.close();
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
  /// Пробегаем по всем записям из JSON-лога,
  /// отправляем каждую на Яндекс.Диск и обновляем флаг isSynced при успехе.
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

    // final appDir = await localRepo.getAppDirectory(path: '/'); // Эта строка, возможно, не нужна здесь

    // Создаем временный список для итерации
    final List<dynamic> itemsToSync = List.from(array);

    for (int i = 0; i < itemsToSync.length; i++) {
      final raw = itemsToSync[i];
      final entry = FileJSON.fromJson(raw as Map<String, dynamic>);

      // Проверяем, нужно ли синхронизировать эту запись
      if (entry.isSynced) {
        continue; // Пропускаем уже синхронизированные
      }

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

        // Успешно обработали запись — обновляем флаг isSynced в исходном массиве
        final originalEntryIndex = array.indexWhere((item) =>
            item['uploadPath'] == entry.uploadPath &&
            item['remotePath'] == entry.remotePath &&
            item['type'] == entry.type);

        if (originalEntryIndex != -1) {
          array[originalEntryIndex]['isSynced'] = true;
          debugPrint(
              '✅ Успешно синхронизировано: ${entry.uploadPath}'); // Для отладки
        }
      } catch (e) {
        // на неудачу не реагируем, оставляем запись с isSynced = false
        debugPrint(
            '⚠️ Ошибка синхронизации ${entry.uploadPath}: $e'); // Для отладки
      }
    }

    // Перезаписываем лог со всеми записями (включая обновленные)
    await logFile.writeAsString(jsonEncode(array), flush: true);

    // Опционально: удалить синхронизированные записи из лога после перезапуска приложения
    // или добавить отдельную функцию для очистки лога
  }

  /// Метод для ручного запуска синхронизации
  Future<void> synchronizeFiles() async {
    if (_hasInternet) {
      await _syncLog();
    } else {
      debugPrint(
          'Нет интернет-соединения для синхронизации.'); // Или другое уведомление пользователю
    }
  }
}
