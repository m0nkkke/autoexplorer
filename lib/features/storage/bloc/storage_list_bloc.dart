import 'dart:async';
import 'dart:developer';
import 'package:autoexplorer/repositories/storage/abstract_storage_repository.dart';
import 'package:autoexplorer/repositories/storage/local_repository.dart';
import 'package:autoexplorer/repositories/storage/storage_repository.dart';
// import 'package:autoexplorer/repositories/storage/storage_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  FutureOr<void> _onStorageListUploadFile(
      StorageListUploadFile event, Emitter<StorageListState> emit) async {
    try {
      emit(StorageListLoading());
      await localRepository.uploadFile(
        filePath: event.filePath,
        uploadPath: event.uploadPath,
      );
      add(StorageListLoad(path: event.currentPath));
    } catch (e) {
      print(e.toString());
      emit(StorageListLoadingFailure(exception: e));
    }
  }

  FutureOr<void> _onStorageListCreateFolder(
      StorageListCreateFolder event, Emitter<StorageListState> emit) async {
    try {
      emit(StorageListLoading());
      print('creating folder ${event.path}');
      print('📁 Creating folder: ${event.name}');
      print('📂 Inside path: ${event.path}');
      await localRepository.createFolder(name: event.name, path: event.path);
      add(StorageListLoad(path: event.path));
    } catch (e) {
      print(e.toString());
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
      // единый вызов
      await yandexRepository.syncAll(path: event.path);
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
