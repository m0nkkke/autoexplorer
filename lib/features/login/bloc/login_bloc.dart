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
      final user = await _usersRepository.getUserByAccessKey(event.accessKey);
      
      if (user == null) {
        emit(state.copyWith(
          status: LoginStatus.failure,
          errorMessage: 'Пользователь не найден',
        ));
        return;
      }

      final isPasswordValid = await _usersRepository.verifyPassword(
        event.accessKey,
        event.password,
      );

      if (isPasswordValid) {
        emit(state.copyWith(
          status: LoginStatus.success,
          role: user.role,
        ));
      } else {
        emit(state.copyWith(
          status: LoginStatus.failure,
          errorMessage: 'Неверный пароль',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: e.toString(),
      ));
    }
   }
}