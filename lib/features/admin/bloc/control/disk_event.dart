part of 'disk_bloc.dart';

abstract class DiskEvent extends Equatable {}

class DiskLoadFoldersEvent extends DiskEvent {
  @override
  List<Object> get props => [];
}

class DiskCreateFolderEvent extends DiskEvent {
  final String folderName;

  DiskCreateFolderEvent({required this.folderName});
  @override
  List<Object?> get props => [];
}
