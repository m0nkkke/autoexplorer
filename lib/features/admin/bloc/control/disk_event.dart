part of 'disk_bloc.dart';

abstract class DiskEvent extends Equatable {}

class LoadFolders extends DiskEvent {
  @override
  List<Object> get props => [];
}
