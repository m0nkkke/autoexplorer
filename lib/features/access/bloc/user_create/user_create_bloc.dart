import 'package:autoexplorer/repositories/users/abstract_users_repository.dart';
import 'package:autoexplorer/repositories/users/models/accessList/access_list.dart';
import 'package:autoexplorer/repositories/users/models/user/user.dart';
import 'package:autoexplorer/repositories/users/models/user/user_role.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_create_event.dart';
part 'user_create_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final AbstractUsersRepository _usersRepository;

  UserBloc(this._usersRepository) : super(UserState.initial()) {
    on<CreateUserEvent>(_onCreateUserEvent);
  }

  Future<void> _onCreateUserEvent(
      CreateUserEvent event, Emitter<UserState> emit) async {
    emit(state.copyWith(status: UserStatus.loading));

    try {
      final user = User(
        accessKey: event.accessKey,
        accessEdit: event.accessEdit,
        accessList: event.accessList,
        accessSet: event.accessSet,
        firstName: event.firstName,
        imagesCount: event.imagesCount,
        lastName: event.lastName,
        lastUpload: event.lastUpload,
        middleName: event.middleName,
        password: event.password,
        role: event.role,
      );

      await _usersRepository.createUser(user);

      emit(state.copyWith(
        status: UserStatus.success,
        user: user,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: UserStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}