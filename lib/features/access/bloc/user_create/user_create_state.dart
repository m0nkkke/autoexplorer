part of 'user_create_bloc.dart';

enum CreateStatus { initial, loading, success, failure }

class UserCreateState extends Equatable {
  final String firstName;
  final String lastName;
  final String middleName;
  final String email;
  final String password;
  final UserRole role;
  final String regional;
  final Set<String> selectedAreas;

  final bool isRegionsLoading;
  final bool isAreasLoading;
  final List<FolderItem> regionalFolderList;
  final Map<String, String> regionalIdsMap;
  final Map<String, String> areasIdsMap;

  final CreateStatus status;
  final String? errorMessage;

  const UserCreateState({
    this.firstName = '',
    this.lastName = '',
    this.middleName = '',
    this.email = '',
    this.password = '',
    this.role = UserRole.worker,
    this.regional = '',
    this.selectedAreas = const {},

    this.isRegionsLoading = false,
    this.isAreasLoading = false,
    this.regionalFolderList = const [],
    this.regionalIdsMap = const {},
    this.areasIdsMap = const {},

    this.status = CreateStatus.initial,
    this.errorMessage,
  });

  UserCreateState copyWith({
    String? firstName,
    String? lastName,
    String? middleName,
    String? email,
    String? password,
    UserRole? role,
    String? regional,
    Set<String>? selectedAreas,

    bool? isRegionsLoading,
    bool? isAreasLoading,
    List<FolderItem>? regionalFolderList,
    Map<String, String>? regionalIdsMap,
    Map<String, String>? areasIdsMap,

    CreateStatus? status,
    String? errorMessage,
  }) {
    return UserCreateState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      middleName: middleName ?? this.middleName,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      regional: regional ?? this.regional,
      selectedAreas: selectedAreas ?? this.selectedAreas,

      isRegionsLoading: isRegionsLoading ?? this.isRegionsLoading,
      isAreasLoading: isAreasLoading ?? this.isAreasLoading,
      regionalFolderList: regionalFolderList ?? this.regionalFolderList,
      regionalIdsMap: regionalIdsMap ?? this.regionalIdsMap,
      areasIdsMap: areasIdsMap ?? this.areasIdsMap,

      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        firstName, lastName, middleName, email, password, role,
        regional, selectedAreas,
        isRegionsLoading, isAreasLoading,
        regionalFolderList, regionalIdsMap, areasIdsMap,
        status, errorMessage,
      ];
}
