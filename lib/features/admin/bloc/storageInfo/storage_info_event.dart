part of 'storage_info_bloc.dart';

abstract class StorageInfoEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Запросить свежие данные по состоянию хранилища
class LoadStorageInfo extends StorageInfoEvent {}
