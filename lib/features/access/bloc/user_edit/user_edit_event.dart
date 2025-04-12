part of 'user_edit_bloc.dart';

abstract class UserEditEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class UpdateFieldEvent extends UserEditEvent {
  final String fieldName;
  final String newValue;

  UpdateFieldEvent(this.fieldName, this.newValue);

  @override
  List<Object> get props => [fieldName, newValue];
}

class UpdateAreasEvent extends UserEditEvent {
  final List<String> areas;

  UpdateAreasEvent(this.areas);
}

class SubmitUserEvent extends UserEditEvent {
  final AEUser updatedUser; 

  SubmitUserEvent(this.updatedUser);
}

class UpdateAccessListEvent extends UserEditEvent {
  final List<String> accessList;

  UpdateAccessListEvent(this.accessList);
}