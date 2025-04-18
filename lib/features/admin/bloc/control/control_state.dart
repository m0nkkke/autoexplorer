part of 'control_bloc.dart';

enum ControlStatus { initial, loading, success, failure }

class ControlState extends Equatable {
  final ControlStatus status;
  final List<QueryDocumentSnapshot> users;
  final String errorMessage;
  final String? folderName;

  const ControlState({
    this.status = ControlStatus.initial,
    this.users = const [],
    this.errorMessage = '',
    this.folderName,
  });

  ControlState copyWith({
    ControlStatus? status,
    List<QueryDocumentSnapshot>? users,
    String? errorMessage,
    String? folderName,
  }) {
    return ControlState(
      status: status ?? this.status,
      users: users ?? this.users,
      errorMessage: errorMessage ?? this.errorMessage,
      folderName: folderName ?? this.folderName,
    );
  }

  @override
  List<Object?> get props => [status, users, errorMessage, folderName];
}
