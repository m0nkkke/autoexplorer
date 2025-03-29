part of 'storage_list_bloc.dart';

abstract class StorageListEvent {}

class StorageListLoad extends StorageListEvent {
  final String path;

  StorageListLoad({required this.path});
}

class StorageListCreateFolder extends StorageListEvent {
  final String path;
  final String name;

  StorageListCreateFolder({required this.path, required this.name});
}
