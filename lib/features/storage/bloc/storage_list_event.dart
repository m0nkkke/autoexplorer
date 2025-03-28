part of 'storage_list_bloc.dart';

abstract class StorageListEvent {}

class StorageListLoad extends StorageListEvent {
  final String path;

  StorageListLoad({required this.path});
}
