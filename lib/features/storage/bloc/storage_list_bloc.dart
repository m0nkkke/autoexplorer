import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:autoexplorer/connectivityService.dart';
import 'package:autoexplorer/global.dart';
import 'package:autoexplorer/repositories/storage/abstract_storage_repository.dart';
import 'package:autoexplorer/repositories/storage/local_repository.dart';
import 'package:autoexplorer/repositories/storage/models/file_json.dart';
import 'package:autoexplorer/repositories/storage/models/folder.dart';
import 'package:autoexplorer/repositories/storage/models/sortby.dart';
import 'package:autoexplorer/repositories/storage/storage_repository.dart';
import 'package:autoexplorer/repositories/users/abstract_users_repository.dart';
import 'package:autoexplorer/repositories/users/models/user/ae_user_role.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as p;
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
part 'storage_list_event.dart';
part 'storage_list_state.dart';

class StorageListBloc extends Bloc<StorageListEvent, StorageListState> {
  bool _accessInitialized = false;
  late UserRole _role;
  late List<String> _accessList;

  /// resourceId → path корневых папок (все регионалы)
  final Map<String, String> _rootMap = {};

  /// resourceId → path подпапок первого уровня внутри регионала
  final Map<String, String> _allowedPaths = {};

  /// resourceId региона из БД
  late String _userRegionalId;

  /// настоящий путь к папке‑региона (disk:/РегионX)
  String? _userRegionalPath;

  bool _regionInitialized = false;
  late StreamSubscription<bool> _internetAvailableSubscription;
  final ConnectivityService _connectivityService =
      GetIt.I<ConnectivityService>();

  StorageListBloc() : super(StorageListInitial()) {
    on<StorageListLoad>(_onStorageListLoad);
    on<StorageListCreateFolder>(_onStorageListCreateFolder);
    on<StorageListUploadFile>(_onStorageListUploadFile);
    on<LoadImageUrl>(_onLoadImageUrl);
    on<ResetImageLoadingState>(_onResetImageLoadingState);
    on<DeleteFolderEvent>(_onDeleteFolder);
    // Переименовали и переработали SyncAllEvent
    on<ManualSyncEvent>(_onManualSyncEvent);

    GetIt.I<ConnectivityService>().addListener(_onChangeConnectionHandler);
  }

  Future<void> _onChangeConnectionHandler() async {
    if (GetIt.I<ConnectivityService>().hasInternet) {
      try {
        await _initAccess();
        await yandexRepository.syncRegionalAndAreasStructure(
          userRegionalId: _userRegionalId,
          accessList: _accessList,
          isAdmin: _role == UserRole.admin,
        );
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  // Переработанный обработчик ручной синхронизации
  FutureOr<void> _onManualSyncEvent(
    ManualSyncEvent event,
    Emitter<StorageListState> emit,
  ) async {
    if (GetIt.I<ConnectivityService>().hasInternet) {
      emit(StorageListLoading());
      try {
        // Вызываем метод синхронизации из ConnectivityService
        await GetIt.I<ConnectivityService>().synchronizeFiles();
        // После успешной синхронизации обновляем список файлов
        add(StorageListLoad(path: event.currentPath));
      } catch (e) {
        debugPrint('Ошибка при ручной синхронизации: $e');
        emit(StorageListLoadingFailure(
            errorMessage: 'Не удалось синхронизировать данные.'));
      }
    } else {
      // Если нет интернета, можно уведомить пользователя
      debugPrint('Нет интернет-соединения для ручной синхронизации.');
      // Можно добавить emit для отображения сообщения пользователю
    }
  }

  FutureOr<void> _onResetImageLoadingState(
      ResetImageLoadingState event, Emitter<StorageListState> emit) async {
    try {
      emit(StorageListLoaded(items: event.currentItems));
    } catch (e) {
      debugPrint(e.toString());
      emit(StorageListLoadingFailure(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _onLoadImageUrl(
      LoadImageUrl event, Emitter<StorageListState> emit) async {
    try {
      // Если ссылка уже есть (не "-"), используем её
      if (event.imageUrl != '-') {
        emit(ImageUrlLoaded(event.imageUrl));
        return;
      }

      // Если ссылки нет, запрашиваем её
      final url = await localRepository.getImageDownloadUrl(event.path);
      emit(ImageUrlLoaded(url));
    } catch (e) {
      emit(ImageLoadError());
    }
  }

  FutureOr<void> _onStorageListUploadFile(
    StorageListUploadFile event,
    Emitter<StorageListState> emit,
  ) async {
    try {
      emit(StorageListLoading());

      // 1) Копируем файл в локальное хранилище
      await localRepository.uploadFile(
        filePath: event.filePath,
        uploadPath: event.uploadPath,
      );
      final appDir = await localRepository.getAppDirectory(path: '/');
      // абсолютный путь локального файла в applicationData
      final absLocal = p.join(appDir.path, event.uploadPath);
      // относительный путь от applicationData
      final rel = p.relative(absLocal, from: appDir.path);
      // финальный путь для API — с ведущим слэшем
      final remotePath = '/$rel';
      debugPrint("==============================");
      debugPrint(event.uploadPath);
      debugPrint(remotePath);
      debugPrint("==============================");

      if (GetIt.I<ConnectivityService>().hasInternet) {
        // 3) Загружаем на Яндекс.Диск
        try {
          await yandexRepository.uploadFile(
            filePath: event.filePath,
            uploadPath: remotePath,
          );
          debugPrint('⬆️ Файл загружен на Яндекс.Диск: $remotePath');
          // Обновляем UI после успешной загрузки
          add(StorageListLoad(path: event.currentPath));
        } catch (e) {
          debugPrint('⚠️ Не удалось загрузить на Я.Диск: $e');
          // В случае ошибки загрузки на Я.Диск, записываем в лог для последующей синхронизации
          final logEntry = FileJSON(
            type: 'file',
            uploadPath: event.uploadPath,
            remotePath: remotePath,
          );
          await _appendToJsonLog(logEntry);
          // Обновляем UI даже при ошибке загрузки на Я.Диск, чтобы показать локальный файл
          add(StorageListLoad(path: event.currentPath));
        }
      } else {
        final logEntry = FileJSON(
          type: 'file',
          uploadPath: event.uploadPath,
          remotePath: remotePath,
        );
        await _appendToJsonLog(logEntry);
        // Обновляем UI после сохранения в локальный лог
        add(StorageListLoad(path: event.currentPath));
      }
    } catch (e) {
      debugPrint('❌ Ошибка в _onStorageListUploadFile: $e');
      emit(StorageListLoadingFailure(
          errorMessage: 'Не удалось загрузить данные.'));
    }
  }

  FutureOr<void> _onStorageListCreateFolder(
    StorageListCreateFolder event,
    Emitter<StorageListState> emit,
  ) async {
    try {
      emit(StorageListLoading());

      // 1) создаём локально (event.path — полный локальный путь к папке)
      await localRepository.createFolder(
        name: event.name,
        path: event.path,
      );

      // 2) вычисляем «удалённый» путь относительно applicationData
      //    найдём в event.path сегмент 'applicationData'
      const marker = 'applicationData';
      final idx = event.path.indexOf(marker);
      String remoteParent;
      if (idx >= 0) {
        // берём всё, что после 'applicationData'
        remoteParent = event.path.substring(idx + marker.length);
        // гарантируем ведущий слэш
        if (!remoteParent.startsWith('/')) remoteParent = '/$remoteParent';
      } else {
        remoteParent = '/';
      }

      if (GetIt.I<ConnectivityService>().hasInternet) {
        // 4) создаём папку на Яндекс.Диске по относительному пути
        try {
          await yandexRepository.createFolder(
            name: event.name,
            path: remoteParent, // вот здесь уже /Test999 или /
          );
          debugPrint(
              '✅ Папка ${event.name} создана на Яндекс.Диске в $remoteParent');
          // Обновляем UI после успешного создания папки
          add(StorageListLoad(path: event.path));
        } catch (e) {
          debugPrint('⚠️ Не удалось создать папку на Я.Диск: $e');
          // В случае ошибки создания папки на Я.Диске, записываем в лог
          final logEntry = FileJSON(
            type: 'folder',
            uploadPath: event.name,
            remotePath: remoteParent,
          );
          await _appendToJsonLog(logEntry);
          add(StorageListLoad(path: event.path));
        }
      } else {
        final logEntry = FileJSON(
          type: 'folder',
          uploadPath: event.name,
          remotePath: remoteParent,
        );
        await _appendToJsonLog(logEntry);
        // Обновляем UI после сохранения в локальный лог
        add(StorageListLoad(path: event.path));
      }
    } catch (e) {
      debugPrint('❌ Ошибка в _onStorageListCreateFolder: $e');
      emit(StorageListLoadingFailure(
          errorMessage: 'Не удалось загрузить данные.'));
    }
  }

  /// Один раз подтягиваем роль и accessList
  Future<void> _initAccess() async {
    debugPrint("============= Вызов initAccess =============");
    final fb = FirebaseAuth.instance.currentUser;
    if (fb == null) throw Exception('Не авторизованный пользователь');

    // 1) Загружаем данные
    final u = await usersRepository.getUserByUid(fb.uid);
    _role = u!.role;
    _accessList = u.accessList;
    globalAccessList = u.accessList;
    globalRole = u.role;
    _userRegionalId = u.regional;

    // 2) Загружаем **корень** яндекс‑диска, чтобы построить _rootMap
    final rootItems = await yandexRepository.getFileAndFolderModels(path: '');
    final roots = rootItems.whereType<FolderItem>().toList();

    if (_role == UserRole.admin) {
      _accessInitialized = true;
      return;
    }

    _rootMap
      ..clear()
      ..addEntries(roots.map((f) => MapEntry(f.resourceId, f.path)));

    // 3) Один раз вычисляем реальный путь региона
    final rp = _rootMap[_userRegionalId];
    if (rp == null) {
      throw Exception('Регион пользователя не найден');
    }
    _userRegionalPath = rp;

    _accessInitialized = true;
    debugPrint('ЗАВЕРШЕН INIT ACCESS');
  }

  FutureOr<void> _onStorageListLoad(
    StorageListLoad event,
    Emitter<StorageListState> emit,
  ) async {
    try {
      debugPrint("============= Вызов _onStorageListLoad =============");
      emit(StorageListLoading());

      final hasInternet = GetIt.I<ConnectivityService>().hasInternet;

      if (hasInternet) {
        try {
          await _initAccess();
          await yandexRepository.syncRegionalAndAreasStructure(
            userRegionalId: _userRegionalId,
            accessList: _accessList,
            isAdmin: _role == UserRole.admin,
          );
        } catch (e) {
          debugPrint(e.toString());
        }
      }

      // if (!_accessInitialized) {
      //   await _initAccess();
      // }

      debugPrint("========= запуск onStorageListLoad ==========");
      final itemsList = (hasInternet && globalRole == UserRole.admin)
          ? await yandexRepository.getFileAndFolderModels(
              path: event.path,
              searchQuery: event.searchQuery,
              sortBy: event.sortBy,
              ascending: event.ascending,
            )
          : await localRepository.getFileAndFolderModels(
              path: event.path,
              searchQuery: event.searchQuery,
              sortBy: event.sortBy,
              ascending: event.ascending,
            );

      emit(StorageListLoaded(items: itemsList));
    } catch (e, st) {
      debugPrint(e.toString());
      emit(StorageListLoadingFailure(
          errorMessage: 'Не удалось загрузить данные.'));
    }
  }

  FutureOr<void> _onDeleteFolder(
      DeleteFolderEvent event, Emitter<StorageListState> emit) async {
    try {
      emit(StorageListLoading());
      await localRepository.deleteFolder(
        name: event.folderName,
        path: event.currentPath,
      );
      add(StorageListLoad(path: event.currentPath));
    } catch (e) {
      emit(StorageListLoadingFailure(
          errorMessage: 'Не удалось удалить данные.'));
    }
  }

  Future<File> _getLogFile() async {
    // 1. Берём корневую директорию документов приложения:
    final baseDir = await getApplicationDocumentsDirectory();
    // 2. Формируем путь к файлу createLog.json прямо в baseDir,
    //    то есть «рядом» с папкой applicationData
    final logFile = File(p.join(baseDir.path, 'createLog.json'));
    // 3. Если файла нет — создаём и инициализируем пустым массивом
    if (!await logFile.exists()) {
      await logFile.create(recursive: true);
      await logFile.writeAsString('[]', flush: true);
    }
    return logFile;
  }

  Future<void> _appendToJsonLog(FileJSON entry) async {
    final logFile = await _getLogFile();
    final content = await logFile.readAsString();
    final List<dynamic> array = jsonDecode(content);
    array.add(entry.toJson());
    await logFile.writeAsString(jsonEncode(array), flush: true);
  }

  final LocalRepository localRepository =
      GetIt.I<AbstractStorageRepository>(instanceName: 'local_repository')
          as LocalRepository;
  final StorageRepository yandexRepository =
      GetIt.I<AbstractStorageRepository>(instanceName: 'yandex_repository')
          as StorageRepository;
  final AbstractUsersRepository usersRepository =
      GetIt.I<AbstractUsersRepository>();
}
