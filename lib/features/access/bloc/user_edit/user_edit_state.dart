// lib/features/access/bloc/user_edit_state.dart
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

  final bool isRegionsLoading;
  final bool isAreasLoading;

  final List<FolderItem> regionalFolderList;
  final Map<String, String> regionalIdsMap;
  final Map<String, String> areasIdsMap;
  final Set<String> selectedAreas;

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

    this.isRegionsLoading = false,
    this.isAreasLoading = false,

    this.regionalFolderList = const [],
    this.regionalIdsMap = const {},
    this.areasIdsMap = const {},
    this.selectedAreas = const {},
  });

    // Метод для получения текущего времени в формате строки
  String getCurrentTimeString() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-dd-MM HH:mm:ss');
    return formatter.format(now);
  }

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

 UserEditState copyWithField(String fieldName, String newValue) {
    switch (fieldName) {
      case 'firstName':
        return copyWith(firstName: newValue);
      case 'lastName':
        return copyWith(lastName: newValue);
      case 'middleName':
        return copyWith(middleName: newValue);
      default:
        return this;
    }
  }

  /// Your existing copyWith(…) method below
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
    bool? isRegionsLoading,
    bool? isAreasLoading,
    List<FolderItem>? regionalFolderList,
    Map<String, String>? regionalIdsMap,
    Map<String, String>? areasIdsMap,
    Set<String>? selectedAreas,
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
      accessEdit: accessEdit ?? this.accessEdit,
      lastUpload: lastUpload,
      isSaving: isSaving ?? this.isSaving,
      saved: saved ?? this.saved,
      error: error ?? this.error,

      isRegionsLoading: isRegionsLoading ?? this.isRegionsLoading,
      isAreasLoading: isAreasLoading ?? this.isAreasLoading,

      regionalFolderList: regionalFolderList ?? this.regionalFolderList,
      regionalIdsMap: regionalIdsMap ?? this.regionalIdsMap,
      areasIdsMap: areasIdsMap ?? this.areasIdsMap,
      selectedAreas: selectedAreas ?? this.selectedAreas,
    );
  }

  @override
  List<Object?> get props => [
        uid, email, firstName, lastName, middleName,
        regional, accessList, role, accessSet, imagesCount,
        accessEdit, lastUpload,
        isSaving, saved, error,
        isRegionsLoading, isAreasLoading,
        regionalFolderList, regionalIdsMap, areasIdsMap, selectedAreas,
      ];
}
