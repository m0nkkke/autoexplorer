part of 'storage_list_bloc.dart';

abstract class StorageListState extends Equatable {}

class StorageListInitial extends StorageListState {
  @override
  List<Object?> get props => [];
}

class StorageListLoading extends StorageListState {
  @override
  List<Object?> get props => [];
}

class StorageListLoaded extends StorageListState {
  @override
  List<Object?> get props => [items];

  final List<dynamic> items;

  StorageListLoaded({required this.items});
}

class StorageListLoadingFailure extends StorageListState {
  @override
  List<Object?> get props => [];

  final Object? exception;

  StorageListLoadingFailure({required this.exception});
}
