part of 'user_edit_bloc.dart';

class UserEditState extends Equatable {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String middleName;
  final String regional;
  final List<String> accessList;
  final UserRole role;
  final String accessSet;
  final int imagesCount;
  final String accessEdit;
  final String lastUpload;
  final bool isSaving;
  final bool saved;
  final String? error;

  const UserEditState({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.regional,
    required this.accessList,
    required this.role,
    required this.accessSet,
    required this.imagesCount,
    required this.accessEdit,
    required this.lastUpload,
    this.isSaving = false,
    this.saved = false,
    this.error,
  });

  // Метод для получения текущего времени в формате строки
  String getCurrentTimeString() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-dd-MM HH:mm:ss');
    return formatter.format(now);
  }

  // Метод для преобразования AEUser в UserEditState
  factory UserEditState.fromUser(AEUser user) {
    return UserEditState(
      uid: user.uid,
      email: user.email,
      firstName: user.firstName,
      lastName: user.lastName,
      middleName: user.middleName,
      regional: user.regional,
      accessList: user.accessList,
      role: user.role,
      accessSet: user.accessSet,
      imagesCount: user.imagesCount,
      accessEdit: user.accessEdit,
      lastUpload: user.lastUpload,
    );
  }

  AEUser toUser() {
    return AEUser(
      uid: uid,
      email: email,
      firstName: firstName,
      lastName: lastName,
      middleName: middleName,
      regional: regional,
      accessList: accessList,
      role: role,
      accessSet: accessSet,
      imagesCount: imagesCount,
      accessEdit: getCurrentTimeString(), 
      lastUpload: lastUpload,
    );
  }

  UserEditState copyWith({
    String? firstName,
    String? lastName,
    String? middleName,
    String? regional,
    List<String>? accessList,
    String? accessEdit,
    bool? isSaving,
    bool? saved,
    String? error,
  }) {
    return UserEditState(
      uid: uid,
      email: email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      middleName: middleName ?? this.middleName,
      regional: regional ?? this.regional,
      accessList: accessList ?? this.accessList,
      role: role,
      accessSet: accessSet,
      imagesCount: imagesCount,
      lastUpload: lastUpload,
      accessEdit: accessEdit ?? this.accessEdit,
      isSaving: isSaving ?? this.isSaving,
      saved: saved ?? this.saved,
      error: error,
    );
  }

  UserEditState copyWithField(String field, String value) {
    switch (field) {
      case 'firstName':
        return copyWith(firstName: value);
      case 'lastName':
        return copyWith(lastName: value);
      case 'middleName':
        return copyWith(middleName: value);
      case 'regional':
        return copyWith(regional: value);
      case 'accessEdit':
        return copyWith(accessEdit: value);
      default:
        return this;
    }
  }

  @override
  List<Object?> get props => [
        uid, email, firstName, lastName, middleName,
        regional, accessList, role, accessSet, imagesCount,
        accessEdit, isSaving, saved, error
      ];
}
