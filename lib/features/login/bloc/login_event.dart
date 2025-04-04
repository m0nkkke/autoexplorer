import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginButtonPressed extends LoginEvent {
  final String emailKey;
  final String password;

  const LoginButtonPressed({required this.emailKey, required this.password});

  @override
  List<Object> get props => [emailKey, password];
}