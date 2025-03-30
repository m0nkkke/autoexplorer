part of 'user_create_bloc.dart';

abstract class UserEvent {}

class CreateUserEvent extends UserEvent {
  final String accessKey;
  final String accessEdit;
  final AccessList accessList;
  final String accessSet;
  final String firstName;
  final int imagesCount;
  final String lastName;
  final String lastUpload;
  final String middleName;
  final String password;
  final UserRole role;

  CreateUserEvent({
    required this.accessKey,
    required this.accessEdit,
    required this.accessList,
    required this.accessSet,
    required this.firstName,
    required this.imagesCount,
    required this.lastName,
    required this.lastUpload,
    required this.middleName,
    required this.password,
    required this.role,
  });
}
