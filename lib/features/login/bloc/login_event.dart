import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginButtonPressed extends LoginEvent {
  final String accessKey;
  final String password;

  const LoginButtonPressed({required this.accessKey, required this.password});

  @override
  List<Object> get props => [accessKey, password];
}