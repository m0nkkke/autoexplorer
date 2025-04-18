import 'package:autoexplorer/repositories/users/models/user/ae_user_role.dart';
import 'package:equatable/equatable.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  final LoginStatus status;
  final String? errorMessage;
  final UserRole? role;

  const LoginState(this.role, {this.status = LoginStatus.initial, this.errorMessage});

  LoginState copyWith({LoginStatus? status, String? errorMessage, UserRole? role}) {
    return LoginState(
      role ?? this.role,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props  => [status,   errorMessage, role];
}