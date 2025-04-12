part of 'control_bloc.dart';

abstract class ControlEvent extends Equatable {
  const ControlEvent();
}

class DeleteUserEvent extends ControlEvent {
  final String uid;

  const DeleteUserEvent(this.uid);

  @override
  List<Object?> get props => [uid];
}

class LoadUsers extends ControlEvent {
  @override
  List<Object?> get props => [];
}
