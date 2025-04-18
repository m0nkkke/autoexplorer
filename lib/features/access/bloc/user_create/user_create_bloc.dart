import 'package:autoexplorer/repositories/storage/abstract_storage_repository.dart';
import 'package:autoexplorer/repositories/storage/models/folder.dart';
import 'package:autoexplorer/repositories/users/abstract_users_repository.dart';
import 'package:autoexplorer/repositories/users/models/user/ae_user.dart';
import 'package:autoexplorer/repositories/users/models/user/ae_user_role.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

part 'user_create_event.dart';
part 'user_create_state.dart';

class UserCreateBloc extends Bloc<UserCreateEvent, UserCreateState> {
  final AbstractUsersRepository _usersRepo = GetIt.I<AbstractUsersRepository>();
  final AbstractStorageRepository _storageRepo = GetIt.I<AbstractStorageRepository>();

  UserCreateBloc()
      : super(const UserCreateState()) {
    on<UpdateCreateFieldEvent>(_onUpdateField);
    on<LoadCreateRegionsEvent>(_onLoadRegions);
    on<OnCreateRegionChangedEvent>(_onRegionChanged);
    on<LoadCreateAreasEvent>(_onLoadAreas);
    on<OnCreateAreaChangedEvent>(_onAreaChanged);
    on<SubmitCreateEvent>(_onSubmitCreate);
  }

  void _onUpdateField(UpdateCreateFieldEvent e, Emitter<UserCreateState> emit) {
    switch (e.field) {
      case 'firstName':   emit(state.copyWith(firstName: e.value));   break;
      case 'lastName':    emit(state.copyWith(lastName: e.value));    break;
      case 'middleName':  emit(state.copyWith(middleName: e.value));  break;
      case 'email':       emit(state.copyWith(email: e.value));       break;
      case 'password':    emit(state.copyWith(password: e.value));    break;
      case 'role':        emit(state.copyWith(role: e.value));        break;
    }
  }

  Future<void> _onLoadRegions(
      LoadCreateRegionsEvent _, Emitter<UserCreateState> emit) async {
    emit(state.copyWith(isRegionsLoading: true));
    try {
      final list = await _storageRepo.getFileAndFolderModels(path: '/');
      final folders = list.whereType<FolderItem>().toList();
      final map = { for (var f in folders) f.name: f.resourceId };
      emit(state.copyWith(
        isRegionsLoading: false,
        regionalFolderList: folders,
        regionalIdsMap: map,
      ));
    } catch (_) {
      emit(state.copyWith(
          isRegionsLoading: false,
          status: CreateStatus.failure,
          errorMessage: 'Не удалось загрузить регионы'));
    }
  }

  void _onRegionChanged(
      OnCreateRegionChangedEvent e, Emitter<UserCreateState> emit) {
    final id = state.regionalIdsMap[e.regionName]!;
    emit(state.copyWith(regional: id, selectedAreas: {}));
    add(LoadCreateAreasEvent(id));
  }

  Future<void> _onLoadAreas(
      LoadCreateAreasEvent e, Emitter<UserCreateState> emit) async {
    emit(state.copyWith(isAreasLoading: true));
    try {
      final folder = state.regionalFolderList
          .firstWhere((f) => f.resourceId == e.regionId);
      final list = await _storageRepo.getFileAndFolderModels(path: folder.path);
      final map = { for (var f in list.whereType<FolderItem>()) f.name: f.resourceId };
      emit(state.copyWith(
        isAreasLoading: false,
        areasIdsMap: map,
      ));
    } catch (_) {
      emit(state.copyWith(
          isAreasLoading: false,
          status: CreateStatus.failure,
          errorMessage: 'Не удалось загрузить участки'));
    }
  }

  void _onAreaChanged(
      OnCreateAreaChangedEvent e, Emitter<UserCreateState> emit) {
    emit(state.copyWith(selectedAreas: e.areaIds));
  }

  Future<void> _onSubmitCreate(
      SubmitCreateEvent _, Emitter<UserCreateState> emit) async {
    emit(state.copyWith(status: CreateStatus.loading, errorMessage: null));
    try {
      // === Firebase Auth Secondary App ===
      final app = await Firebase.initializeApp(
        name: 'SecondaryApp',
        options: Firebase.app().options,
      );
      final auth = FirebaseAuth.instanceFor(app: app);
      final cred = await auth.createUserWithEmailAndPassword(
        email: state.email.trim(),
        password: state.password.trim(),
      );
      final uid = cred.user!.uid;
      await auth.signOut();
      await app.delete();

      // === Build AEUser ===
      final now = DateFormat('yyyy-dd-MM HH:mm:ss').format(DateTime.now());
      final newUser = AEUser(
        uid: uid,
        email: state.email,
        firstName: state.firstName,
        lastName: state.lastName,
        middleName: state.middleName,
        role: state.role,
        regional: state.regional,
        accessList: state.selectedAreas.toList(),
        accessSet: now,
        accessEdit: now,
        imagesCount: 0,
        lastUpload: 'Никогда',
      );

      await _usersRepo.registerUser(uid, newUser);

      emit(state.copyWith(status: CreateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: CreateStatus.failure, errorMessage: e.toString()));
    }
  }
}
