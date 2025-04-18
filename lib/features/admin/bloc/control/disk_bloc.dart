import 'dart:async';
import 'package:autoexplorer/repositories/storage/abstract_storage_repository.dart';
import 'package:autoexplorer/repositories/storage/models/folder.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'disk_state.dart';
part 'disk_event.dart';

class DiskBloc extends Bloc<DiskEvent, DiskState> {
  DiskBloc({required this.storageRepository}) : super(DiskInitial()) {
    on<DiskLoadFoldersEvent>(_onLoadFolders);
    on<DiskCreateFolderEvent>(_onCreateFolder);
  }

  FutureOr<void> _onLoadFolders(
      DiskLoadFoldersEvent event, Emitter<DiskState> emit) async {
    try {
      final itemsList =
          await storageRepository.getFileAndFolderModels(path: '/');
      final folders = itemsList.whereType<FolderItem>().toList();

      emit(DiskLoaded(folders));
    } catch (e) {
      print(e.toString());
      emit(DiskError(e));
    }
  }

  FutureOr<void> _onCreateFolder(
      DiskCreateFolderEvent event, Emitter<DiskState> emit) async {
    try {
      emit(DiskLoading());

      await storageRepository.createFolder(name: event.folderName, path: '/');
      add(DiskLoadFoldersEvent());
    } catch (e) {
      print(e.toString());
      emit(DiskError(e));
    }
  }

  final AbstractStorageRepository storageRepository;
}
