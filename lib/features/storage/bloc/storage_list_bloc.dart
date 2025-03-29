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
        emit(StorageListLoadingFailure(exception: e));
      }
    });
  }

  final AbstractStorageRepository yandexRepositoy;
}
