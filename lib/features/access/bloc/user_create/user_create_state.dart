part of 'user_create_bloc.dart';

enum UserStatus { initial, loading, success, failure }

class UserState {
  final UserStatus status;
  final String? errorMessage;
  final AEUser? user;

  const UserState({
    required this.status,
    this.errorMessage,
    this.user,
  });

  UserState copyWith({
    UserStatus? status,
    String? errorMessage,
    AEUser? user,
  }) {
    return UserState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
    );
  }

  factory UserState.initial() {
    return const UserState(status: UserStatus.initial);
  }
}