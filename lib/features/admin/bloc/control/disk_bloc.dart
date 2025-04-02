import 'package:autoexplorer/repositories/storage/abstract_storage_repository.dart';
import 'package:autoexplorer/repositories/storage/models/folder.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'disk_state.dart';
part 'disk_event.dart';

class DiskBloc extends Bloc<DiskEvent, DiskState> {
  DiskBloc({required this.storageRepository}) : super(DiskInitial()) {
    on<LoadFolders>((event, emit) async {
      try {
        final itemsList =
            await storageRepository.getFileAndFolderModels(path: '/');
        emit(DiskLoaded(itemsList));
      } catch (e) {
        print(e.toString());
        emit(DiskError(e));
      }
    });
  }

  final AbstractStorageRepository storageRepository;
}
