part of 'user_create_bloc.dart';

abstract class UserEvent {}

class CreateUserEvent extends UserEvent {
  final String accessEdit;
  final List<String> accessList;
  final String regional;
  final String accessSet;
  final String firstName;
  final int imagesCount;
  final String lastName;
  final String lastUpload;
  final String middleName;
  final String email; 
  final String password; 
  final UserRole role;
  final String uid;

  CreateUserEvent({
    required this.accessEdit,
    required this.regional,
    required this.accessList,
    required this.accessSet,
    required this.firstName,
    required this.imagesCount,
    required this.lastName,
    required this.lastUpload,
    required this.middleName,
    required this.email,
    required this.password,
    required this.role,
    required this.uid,
  });
}