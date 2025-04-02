part of 'disk_bloc.dart';

abstract class DiskState extends Equatable {}

class DiskInitial extends DiskState {
  @override
  List<Object> get props => [];
}

class DiskLoading extends DiskState {
  @override
  List<Object> get props => [];
}

class DiskLoaded extends DiskState {
  final List<dynamic> items;

  DiskLoaded(this.items);

  @override
  List<Object> get props => [items];
}

class DiskError extends DiskState {
  final Object e;

  DiskError(this.e);

  @override
  List<Object> get props => [e];
}
