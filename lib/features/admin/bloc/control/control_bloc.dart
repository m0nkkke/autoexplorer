import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:autoexplorer/repositories/users/users_repository.dart'; 

part 'control_event.dart';
part 'control_state.dart';

class ControlBloc extends Bloc<ControlEvent, ControlState> {
  final UsersRepository _usersRepository;

  ControlBloc(this._usersRepository) : super(ControlState()) {
    on<LoadUsers>(_onLoadUsers);
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
