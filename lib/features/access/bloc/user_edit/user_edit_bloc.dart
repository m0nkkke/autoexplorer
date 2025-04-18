// lib/features/access/bloc/user_edit_bloc.dart
import 'package:autoexplorer/repositories/storage/abstract_storage_repository.dart';
import 'package:autoexplorer/repositories/storage/models/folder.dart';
import 'package:autoexplorer/repositories/users/abstract_users_repository.dart';
import 'package:autoexplorer/repositories/users/models/user/ae_user_role.dart';
import 'package:autoexplorer/repositories/users/models/user/ae_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

part 'user_edit_event.dart';
part 'user_edit_state.dart';

class UserEditBloc extends Bloc<UserEditEvent, UserEditState> {
  final AbstractUsersRepository _userRepo = GetIt.I<AbstractUsersRepository>();
  final AbstractStorageRepository _storage = GetIt.I<AbstractStorageRepository>();

  UserEditBloc(AEUser initialUser)
      : super(UserEditState.fromUser(initialUser)) {
    on<UpdateFieldEvent>((e, emit) {
      emit(state.copyWithField(e.fieldName, e.newValue));
    });

    on<LoadRegionsEvent>((_, emit) async {
      emit(state.copyWith(isRegionsLoading: true));
      try {
        final list = await _storage.getFileAndFolderModels(path: '/');
        final map = <String,String>{};
        final folders = <FolderItem>[];
        for (var f in list.whereType<FolderItem>()) {
          folders.add(f);
          map[f.name] = f.resourceId;
        }
        emit(state.copyWith(
          isRegionsLoading: false,
          regionalFolderList: folders,
          regionalIdsMap: map,
        ));
        if (state.regional.isNotEmpty) {
          add(LoadAreasEvent(state.regional));
        }
      } catch (_) {
        emit(state.copyWith(isRegionsLoading: false, error: 'Не удалось загрузить регионы'));
      }
    });

    on<OnRegionChangedEvent>((e, emit) async {
      final id = state.regionalIdsMap[e.regionName]!;
      emit(state.copyWith(
        regional: id,
        selectedAreas: {},
      ));
      add(LoadAreasEvent(id));
    });

    on<LoadAreasEvent>((e, emit) async {
      emit(state.copyWith(isAreasLoading: true));
      try {
        final folder = state.regionalFolderList
            .firstWhere((f) => f.resourceId == e.regionId);
        final list = await _storage.getFileAndFolderModels(path: folder.path);

        final map = <String,String>{};
        final sel = <String>{};
        for (var f in list.whereType<FolderItem>()) {
          map[f.name] = f.resourceId;
          if (state.accessList.contains(f.resourceId)) {
            sel.add(f.resourceId);
          }
        }

        emit(state.copyWith(
          isAreasLoading: false,
          areasIdsMap: map,
          selectedAreas: sel,
        ));
      } catch (_) {
        emit(state.copyWith(isAreasLoading: false, error: 'Не удалось загрузить участки'));
      }
    });

    on<OnAreaChangedEvent>((e, emit) {
      emit(state.copyWith(selectedAreas: e.newAreas));
    });

    on<SubmitUserEvent>((_, emit) async {
      emit(state.copyWith(isSaving: true, error: null));
      try {
        final u = state.toUser()
          ..accessList = state.selectedAreas.toList();
        await _userRepo.updateUser(u);
        emit(state.copyWith(isSaving: false, saved: true));
      } catch (_) {
        emit(state.copyWith(isSaving: false, error: 'Ошибка при сохранении'));
      }
    });
  }
}
