import 'package:autoexplorer/features/login/bloc/login_event.dart';
import 'package:autoexplorer/features/login/bloc/login_state.dart';
import 'package:autoexplorer/repositories/users/abstract_users_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AbstractUsersRepository _usersRepository;

  LoginBloc(this._usersRepository) : super(const LoginState(null)) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }

  Future<void> _onLoginButtonPressed(
      LoginButtonPressed event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: LoginStatus.loading));

    try {
      final user = await _usersRepository.signInUser(event.emailKey, event.password);

      if (user == null) {
        emit(state.copyWith(
          status: LoginStatus.failure,
          errorMessage: 'Неверный email или пароль',
        ));
        return;
      }

      emit(state.copyWith(
        status: LoginStatus.success,
        role: user.role,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}