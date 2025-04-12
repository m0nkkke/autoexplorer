import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:autoexplorer/repositories/users/users_repository.dart';
import 'package:equatable/equatable.dart'; 

part 'control_event.dart';
part 'control_state.dart';

class ControlBloc extends Bloc<ControlEvent, ControlState> {
  final UsersRepository _usersRepository;

  ControlBloc(this._usersRepository) : super(ControlState()) {
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
