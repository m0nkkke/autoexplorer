import 'package:autoexplorer/repositories/users/models/user/ae_user_role.dart';
import 'package:autoexplorer/repositories/users/users_repository.dart';
import 'package:autoexplorer/repositories/users/models/user/ae_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

part 'user_edit_event.dart';
part 'user_edit_state.dart';

class UserEditBloc extends Bloc<UserEditEvent, UserEditState> {
  final UsersRepository repository;  

  UserEditBloc(this.repository, AEUser initialUser)
    : super(UserEditState.fromUser(initialUser)) {
  on<UpdateFieldEvent>((event, emit) {
    emit(state.copyWithField(event.fieldName, event.newValue));
  });

  on<UpdateAreasEvent>((event, emit) {
    emit(state.copyWith(accessList: event.areas));
  });

  on<UpdateAccessListEvent>((event, emit) {
    emit(state.copyWith(accessList: event.accessList)); 
  });

  on<SubmitUserEvent>((event, emit) async {
    emit(state.copyWith(isSaving: true));

    try {
      final updatedUser = event.updatedUser;
      updatedUser.accessList = state.accessList;
      
      await repository.updateUser(updatedUser);

      emit(state.copyWith(isSaving: false, saved: true));
    } catch (_) {
      emit(state.copyWith(isSaving: false, error: 'Ошибка при сохранении'));
    }
  });
  }
}