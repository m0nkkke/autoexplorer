import 'package:autoexplorer/repositories/users/abstract_users_repository.dart';
import 'package:autoexplorer/repositories/users/models/user/ae_user.dart';
import 'package:autoexplorer/repositories/users/models/user/ae_user_role.dart';
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
      // Создаем объект AEUser с данными, полученными из события
      final user = AEUser(
        accessEdit: event.accessEdit,
        regional: event.regional,
        accessList: event.accessList,
        accessSet: event.accessSet,
        firstName: event.firstName,
        imagesCount: event.imagesCount,
        lastName: event.lastName,
        lastUpload: event.lastUpload,
        middleName: event.middleName,
        role: event.role,
        uid: event.uid,
        email: event.email, 
      );

      // Регистрируем пользователя в Firestore, передавая uid
      await _usersRepository.registerUser(event.uid, user);  // Используем registerUser с уже существующим uid

      // Если регистрация прошла успешно, обновляем состояние
      emit(state.copyWith(
        status: UserStatus.success,
        user: user,
      ));
    } catch (e) {
      // В случае ошибки, обновляем состояние с сообщением об ошибке
      emit(state.copyWith(
        status: UserStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
