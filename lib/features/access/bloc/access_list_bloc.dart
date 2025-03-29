import 'package:autoexplorer/repositories/users/abstract_users_repository.dart';
import 'package:autoexplorer/repositories/users/models/accessList/access_list.dart';
import 'package:autoexplorer/repositories/users/models/user/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'access_list_event.dart';
part 'access_list_state.dart';

class AccessListBloc extends Bloc<AccessListEvent, AccessListState> {
  final AbstractUsersRepository usersRepository;

  AccessListBloc({required this.usersRepository}) : super(AccessListInitial()) {
    on<LoadAccessList>(_onLoadAccessList);
  }

  Future<void> _onLoadAccessList(
    LoadAccessList event,
    Emitter<AccessListState> emit,
  ) async {
    emit(AccessListLoading());
    try {
      final user = await usersRepository.getUserByAccessKey(event.accessKey);
      if (user != null) {
        emit(AccessListLoaded(accessList: user.accessList, user: user));
      } else {
        emit(AccessListError(error: 'Пользователь не найден'));
      }
    } catch (e) {
      emit(AccessListError(error: 'Ошибка загрузки данных: ${e.toString()}'));
    }
  }
}