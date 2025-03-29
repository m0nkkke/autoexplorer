import 'package:autoexplorer/repositories/storage/abstract_storage_repository.dart';
// import 'package:autoexplorer/repositories/storage/storage_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'storage_list_event.dart';
part 'storage_list_state.dart';

class StorageListBloc extends Bloc<StorageListEvent, StorageListState> {
  StorageListBloc(this.yandexRepositoy) : super(StorageListInitial()) {
    on<StorageListLoad>((event, emit) async {
      try {
        final itemsList =
            await yandexRepositoy.getFileAndFolderModels(path: event.path);
        emit(StorageListLoaded(items: itemsList));
      } catch (e) {
        emit(StorageListLoadingFailure(exception: e));
      }
    });
    on<StorageListCreateFolder>((event, emit) async {
      try {
        emit(StorageListLoading());

        await yandexRepositoy.createFolder(name: event.name, path: event.path);
        add(StorageListLoad(path: event.path));
      } catch (e) {
        print(e.toString());
        emit(StorageListLoadingFailure(exception: e));
      }
    });
    on<StorageListUploadFile>((event, emit) async {
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
    });
    on<LoadImageUrl>((event, emit) async {
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
    });
  }

  final AbstractStorageRepository yandexRepositoy;
}
