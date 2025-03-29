part of 'access_list_bloc.dart';

abstract class AccessListState {}

class AccessListInitial extends AccessListState {}

class AccessListLoading extends AccessListState {}

class AccessListLoaded extends AccessListState {
  final AccessList accessList;
  final User user;

  AccessListLoaded({required this.accessList, required this.user});
}

class AccessListError extends AccessListState {
  final String error;

  AccessListError({required this.error});
}