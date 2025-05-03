import 'package:autoexplorer/repositories/storage/models/folder.dart';
import 'package:autoexplorer/repositories/users/abstract_users_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:autoexplorer/repositories/storage/abstract_storage_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

part 'control_event.dart';
part 'control_state.dart';

class ControlBloc extends Bloc<ControlEvent, ControlState> {
  final AbstractUsersRepository _usersRepository = GetIt.I<AbstractUsersRepository>();
  final AbstractStorageRepository _storageRepository =  GetIt.I<AbstractStorageRepository>(instanceName: 'yandex_repository');
  

  ControlBloc() : super(ControlState()) {
    on<LoadUsers>(_onLoadUsers);

    on<DeleteUserEvent>((event, emit) async {
      try {
        await _usersRepository.deleteUser(event.uid); // Удаляем пользователя из репозитория
        emit(state.copyWith(status: ControlStatus.success));
        add(LoadUsers()); // Загружаем пользователей снова
      } catch (e) {
        emit(state.copyWith(status: ControlStatus.failure, errorMessage: e.toString()));
      }
    });
  
  }

  Future<void> _onLoadUsers(
      LoadUsers event, Emitter<ControlState> emit) async {
    emit(state.copyWith(status: ControlStatus.loading));

    try {
      final usersSnapshot = await _usersRepository.getUsers();
      final usersList = usersSnapshot.docs;

      final folders = await _storageRepository.getFileAndFolderModels(path: '');
      final regionNamesMap = <String, String>{};
      for (var f in folders.whereType<FolderItem>()) {
        regionNamesMap[f.resourceId] = f.name;
      }

      emit(state.copyWith(
        status: ControlStatus.success,
        users: usersList,
        regionNamesMap: regionNamesMap,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ControlStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
