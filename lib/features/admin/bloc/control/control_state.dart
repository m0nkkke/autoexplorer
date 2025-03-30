part of 'control_bloc.dart';

enum ControlStatus { initial, loading, success, failure }

class ControlState {
  final ControlStatus status;
  final List<QueryDocumentSnapshot> users;
  final String errorMessage;

  ControlState({
    this.status = ControlStatus.initial,
    this.users = const [],
    this.errorMessage = '',
  });

  ControlState copyWith({
    ControlStatus? status,
    List<QueryDocumentSnapshot>? users,
    String? errorMessage,
  }) {
    return ControlState(
      status: status ?? this.status,
      users: users ?? this.users,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
