import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:autoexplorer/connectivityService.dart';
import 'package:autoexplorer/repositories/storage/abstract_storage_repository.dart';
import 'package:autoexplorer/repositories/storage/local_repository.dart';
import 'package:autoexplorer/repositories/storage/models/file_json.dart';
import 'package:autoexplorer/repositories/storage/models/folder.dart';
import 'package:autoexplorer/repositories/storage/storage_repository.dart';
import 'package:autoexplorer/repositories/users/abstract_users_repository.dart';
import 'package:autoexplorer/repositories/users/models/user/ae_user_role.dart';
// import 'package:autoexplorer/repositories/storage/storage_repository.dart';
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

  StorageListBloc() : super(StorageListInitial()) {
    on<StorageListLoad>(_onStorageListLoad);
    on<StorageListCreateFolder>(_onStorageListCreateFolder);
    on<StorageListUploadFile>(_onStorageListUploadFile);
    on<LoadImageUrl>(_onLoadImageUrl);
    on<ResetImageLoadingState>(_onResetImageLoadingState);
    // on<SyncFromYandexEvent>(_onSyncFromYandex);
    on<SyncToYandexEvent>(_onSyncToYandex);
    on<DeleteFolderEvent>(_onDeleteFolder);
    on<SyncAllEvent>(_onSyncAreasFromYandex);

    GetIt.I<ConnectivityService>().addListener(_onChangeConnectionHandler);
  }

  Future<void> _onChangeConnectionHandler() async {
    if (GetIt.I<ConnectivityService>().hasInternet) {
      await _initAccess();
      await yandexRepository.syncRegionalAndAreasStructure(
        userRegionalId: _userRegionalId,
        accessList: _accessList,
        isAdmin: _role == UserRole.admin,
      );
    }
  }

  Future<void> _onSyncAreasFromYandex(
    SyncAllEvent event,
    Emitter<StorageListState> emit,
  ) async {
    if (GetIt.I<ConnectivityService>().hasInternet) {
      await _initAccess();
      emit(StorageListLoading());
      await yandexRepository.syncRegionalAndAreasStructure(
        userRegionalId: _userRegionalId,
        accessList: _accessList,
        isAdmin: _role == UserRole.admin,
      );
      add(StorageListLoad(path: event.path));
    }
  }

  FutureOr<void> _onResetImageLoadingState(
      ResetImageLoadingState event, Emitter<StorageListState> emit) async {
    try {
      emit(StorageListLoaded(items: event.currentItems));
    } catch (e) {
      print(e.toString());
      emit(StorageListLoadingFailure(exception: e));
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

  // FutureOr<void> _onStorageListUploadFile(
  //     StorageListUploadFile event, Emitter<StorageListState> emit) async {
  //   try {
  //     emit(StorageListLoading());
  //     await localRepository.uploadFile(
  //       filePath: event.filePath,
  //       uploadPath: event.uploadPath,
  //     );
  //     add(StorageListLoad(path: event.currentPath));
  //   } catch (e) {
  //     print(e.toString());
  //     emit(StorageListLoadingFailure(exception: e));
  //   }
  // }

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

      // 2) Обновляем UI
      add(StorageListLoad(path: event.currentPath));

      if (GetIt.I<ConnectivityService>().hasInternet) {
        // 3) Строим удалённый путь, вырезая всё до applicationData

        // 4) Загружаем на Яндекс.Диск
        try {
          await yandexRepository.uploadFile(
            filePath: event.filePath,
            uploadPath: remotePath,
          );
          print('⬆️ Файл загружен на Яндекс.Диск: $remotePath');
        } catch (e) {
          print('⚠️ Не удалось загрузить на Я.Диск: $e');
        }
      } else {
        final logEntry = FileJSON(
          type: 'file',
          uploadPath: event.uploadPath,
          remotePath: remotePath,
        );
        await _appendToJsonLog(logEntry);
      }
    } catch (e) {
      print('❌ Ошибка в _onStorageListUploadFile: $e');
      emit(StorageListLoadingFailure(exception: e));
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
      // 3) обновляем UI
      add(StorageListLoad(path: event.path));

      if (GetIt.I<ConnectivityService>().hasInternet) {
        // 4) создаём папку на Яндекс.Диске по относительному пути
        await yandexRepository.createFolder(
          name: event.name,
          path: remoteParent, // вот здесь уже /Test999 или /
        );
        print('✅ Папка ${event.name} создана на Яндекс.Диске в $remoteParent');
      } else {
        final logEntry = FileJSON(
          type: 'folder',
          uploadPath: event.name,
          remotePath: remoteParent,
        );
        await _appendToJsonLog(logEntry);
      }
    } catch (e) {
      print('❌ Ошибка в _onStorageListCreateFolder: $e');
      emit(StorageListLoadingFailure(exception: e));
    }
  }

  /// Один раз подтягиваем роль и accessList
  Future<void> _initAccess() async {
    final fb = FirebaseAuth.instance.currentUser;
    if (fb == null) throw Exception('Не авторизованный пользователь');

    // 1) Загружаем данные юзера
    final u = await usersRepository.getUserByUid(fb.uid);
    _role = u!.role;
    _accessList = u.accessList;
    _userRegionalId = u.regional; // resourceId

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
  }

// FutureOr<void> _onStorageListLoad(
//   StorageListLoad event,
//   Emitter<StorageListState> emit,
// ) async {
//   emit(StorageListLoading());

//   if (!_accessInitialized) {
//     await _initAccess();
//   }

//   // 1) Грузим именно ту папку, в которую просят зайти
//   final repoPath = event.path == '/'
//       ? ''
//       : event.path.startsWith('disk:')
//           ? event.path
//           : 'disk:/${event.path}';
//   final items =
//       await yandexRepository.getFileAndFolderModels(path: repoPath);

//   List<dynamic> filtered;

//   // --- A) Корень: просто показываем всё ---
//   if (event.path == '/' || event.path == 'disk:/') {
//     filtered = items.whereType<FolderItem>().toList();

//     // сбрасываем флаг, чтобы при первом заходе в регион “allowedPaths” собрался
//     _regionInitialized = false;

//   // --- B) Первый заход в регионалог _userRegionalPath ---
//   } else if (!_regionInitialized && event.path == _userRegionalPath) {
//     if (_role == UserRole.admin) {
//       filtered = items;
//     } else {
//       // строим allowedPaths из подпапок первого уровня
//       _allowedPaths
//         ..clear()
//         ..addEntries(items
//           .whereType<FolderItem>()
//           .where((f) => _accessList.contains(f.resourceId))
//           .map((f) => MapEntry(f.resourceId, f.path)));

//       filtered = items
//           .where((it) =>
//               it is FolderItem && _allowedPaths.containsKey(it.resourceId))
//           .toList();
//     }
//     _regionInitialized = true;

//   // --- C) Любое глубокое вложение внутри региона ---
//   } else {
//     if (_role == UserRole.admin) {
//       // filtered = items;
//     } else {
//       // не давать уйти за пределы своего региона
//       if (!event.path.startsWith(_userRegionalPath!)) {
//         emit(StorageListLoadingFailure(
//             exception: 'Нет доступа к ${event.path}'));
//         return;
//       }
//       // // показываем только те элементы, чей путь лежит внутри любого из allowedPaths
//       // filtered = items.where((it) {
//       //   final pth = (it as dynamic).path as String;
//       //   return _allowedPaths.values.any((base) => pth.startsWith(base));
//       // }).toList();
//     }
//   }

//   emit(StorageListLoaded(items: items));
// }

  FutureOr<void> _onStorageListLoad(
      StorageListLoad event, Emitter<StorageListState> emit) async {
    try {
      late dynamic role;
      try {
        role = _role;
      } catch (e) {
        print("===== catch role =====");
        await _initAccess();
        role = _role;
      }
      late dynamic itemsList;
      print(role);
      if (role == UserRole.worker) {
        itemsList =
            await localRepository.getFileAndFolderModels(path: event.path);
      } else {
        itemsList =
            await yandexRepository.getFileAndFolderModels(path: event.path);
      }
      print(itemsList.toString());
      emit(StorageListLoaded(items: itemsList));
    } catch (e) {
      print(e.toString());
      emit(StorageListLoadingFailure(exception: e));
    }
  }

  // Обработчик события синхронизации с Яндекс Диском
  FutureOr<void> _onSyncFromYandex(
      SyncFromYandexEvent event, Emitter<StorageListState> emit) async {
    try {
      emit(StorageListLoading());
      await yandexRepository.syncFromYandexDisk(); // Синхронизация
      // add(StorageListLoad(
      //     path: event.path)); // Обновление UI после синхронизации
    } catch (e) {
      print('==========onSyncFromYandex=========');
      print(e);
      emit(StorageListLoadingFailure(exception: e));
    }
  }

  // Обработчик события синхронизации с локальным хранилищем
  FutureOr<void> _onSyncToYandex(
      SyncToYandexEvent event, Emitter<StorageListState> emit) async {
    try {
      emit(StorageListLoading());
      await yandexRepository
          .syncToYandexDisk(); // Синхронизация с локального хранилища
      add(StorageListLoad(
          path: event.path)); // Обновление UI после синхронизации
    } catch (e) {
      print('=========onSyncToYandex==========');
      print(e);
      emit(StorageListLoadingFailure(exception: e));
    }
  }

  FutureOr<void> _onSyncAll(
    SyncAllEvent event,
    Emitter<StorageListState> emit,
  ) async {
    try {
      emit(StorageListLoading());
      if (GetIt.I<ConnectivityService>().hasInternet) {
        // единый вызов
        await yandexRepository.syncAll(path: event.path);
      }
      // обновляем UI
      add(StorageListLoad(path: event.path));
    } catch (e) {
      print('=========onSyncAll==========');
      print(e);
      emit(StorageListLoadingFailure(exception: e));
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
      emit(StorageListLoadingFailure(exception: e));
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
