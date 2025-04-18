import 'package:autoexplorer/repositories/users/abstract_users_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:autoexplorer/repositories/storage/abstract_storage_repository.dart';
import 'package:autoexplorer/repositories/users/users_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

part 'control_event.dart';
part 'control_state.dart';

class ControlBloc extends Bloc<ControlEvent, ControlState> {
  final AbstractUsersRepository _usersRepository = GetIt.I<AbstractUsersRepository>();
  final AbstractStorageRepository _storageRepository = GetIt.I<AbstractStorageRepository>();

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
    
    // Обработчик для поиска папки по resource_id
    on<GetFolderNameByResourceIdEvent>((event, emit) async {
      try {
        // Получаем все папки и файлы с помощью getFileAndFolderModels
        final folders = await _storageRepository.getFileAndFolderModels(path: '/'); // Путь к корню

        // Ищем нужную папку по resource_id
        final folder = folders.firstWhere(
          (folder) => folder.resourceId == event.resourceId,
          orElse: () => null, // Если папка не найдена, возвращаем null
        );

        if (folder != null) {
          emit(state.copyWith(status: ControlStatus.success, folderName: folder.name));
        } else {
          emit(state.copyWith(status: ControlStatus.failure, errorMessage: 'Папка не найдена'));
        }
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

      final List<QueryDocumentSnapshot> usersList = usersSnapshot.docs;

      emit(state.copyWith(
        users: usersList,
        status: ControlStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ControlStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
