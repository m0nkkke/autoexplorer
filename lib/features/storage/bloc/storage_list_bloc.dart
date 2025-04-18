import 'dart:async';
import 'package:autoexplorer/repositories/storage/abstract_storage_repository.dart';
// import 'package:autoexplorer/repositories/storage/storage_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'storage_list_event.dart';
part 'storage_list_state.dart';

class StorageListBloc extends Bloc<StorageListEvent, StorageListState> {
  StorageListBloc(this.yandexRepositoy) : super(StorageListInitial()) {
    on<StorageListLoad>(_onStorageListLoad);
    on<StorageListCreateFolder>(_onStorageListCreateFolder);
    on<StorageListUploadFile>(_onStorageListUploadFile);
    on<LoadImageUrl>(_onLoadImageUrl);
    on<ResetImageLoadingState>(_onResetImageLoadingState);
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
      final url = await yandexRepositoy.getImageDownloadUrl(event.path);
      emit(ImageUrlLoaded(url));
    } catch (e) {
      emit(ImageLoadError());
    }
  }

  FutureOr<void> _onStorageListUploadFile(
      StorageListUploadFile event, Emitter<StorageListState> emit) async {
    try {
      emit(StorageListLoading());
      await yandexRepositoy.uploadFile(
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
      await yandexRepositoy.createFolder(name: event.name, path: event.path);
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
          await yandexRepositoy.getFileAndFolderModels(path: event.path);
      print(itemsList.toString());
      emit(StorageListLoaded(items: itemsList));
    } catch (e) {
      print(e.toString());
      emit(StorageListLoadingFailure(exception: e));
    }
  }

  final AbstractStorageRepository yandexRepositoy;
}
