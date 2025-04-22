import 'dart:async';
import 'dart:developer';
import 'package:autoexplorer/connectivityService.dart';
import 'package:autoexplorer/repositories/storage/abstract_storage_repository.dart';
import 'package:autoexplorer/repositories/storage/local_repository.dart';
import 'package:autoexplorer/repositories/storage/storage_repository.dart';
// import 'package:autoexplorer/repositories/storage/storage_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as p;
import 'package:get_it/get_it.dart';
part 'storage_list_event.dart';
part 'storage_list_state.dart';

class StorageListBloc extends Bloc<StorageListEvent, StorageListState> {
  StorageListBloc() : super(StorageListInitial()) {
    on<StorageListLoad>(_onStorageListLoad);
    on<StorageListCreateFolder>(_onStorageListCreateFolder);
    on<StorageListUploadFile>(_onStorageListUploadFile);
    on<LoadImageUrl>(_onLoadImageUrl);
    on<ResetImageLoadingState>(_onResetImageLoadingState);
    on<SyncFromYandexEvent>(_onSyncFromYandex);
    on<SyncToYandexEvent>(_onSyncToYandex);
    on<DeleteFolderEvent>(_onDeleteFolder);
    on<SyncAllEvent>(_onSyncAll);
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
        uploadPath: event.uploadPath, // это путь относительно applicationData
      );
      // 2) Обновляем UI
      add(StorageListLoad(path: event.currentPath));

      if (GetIt.I<ConnectivityService>().hasInternet) {
        // 3) Строим удалённый путь, вырезая всё до applicationData
        final appDir = await localRepository.getAppDirectory(path: '/');
        // абсолютный путь локального файла в applicationData
        final absLocal = p.join(appDir.path, event.uploadPath);
        // относительный путь от applicationData
        final rel = p.relative(absLocal, from: appDir.path);
        // финальный путь для API — с ведущим слэшем
        final remotePath = '/$rel';

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
      }
    } catch (e) {
      print('❌ Ошибка в _onStorageListCreateFolder: $e');
      emit(StorageListLoadingFailure(exception: e));
    }
  }

  FutureOr<void> _onStorageListLoad(
      StorageListLoad event, Emitter<StorageListState> emit) async {
    try {
      final itemsList =
          await localRepository.getFileAndFolderModels(path: event.path);
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

  final LocalRepository localRepository =
      GetIt.I<AbstractStorageRepository>(instanceName: 'local_repository')
          as LocalRepository;
  final StorageRepository yandexRepository =
      GetIt.I<AbstractStorageRepository>(instanceName: 'yandex_repository')
          as StorageRepository;
}
