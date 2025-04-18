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

class StorageListUploadFile extends StorageListEvent {
  final String filePath;
  final String uploadPath;
  final String currentPath;

  StorageListUploadFile({
    required this.filePath,
    required this.uploadPath,
    required this.currentPath,
  });
}

class ImageUrlLoad extends StorageListEvent {
  final String path;

  ImageUrlLoad({required this.path});
}

class LoadImageUrl extends StorageListEvent {
  final String name;
  final String path;
  final String imageUrl;

  LoadImageUrl(
      {required this.name, required this.path, required this.imageUrl});
}

class ResetImageLoadingState extends StorageListEvent {
  final List<dynamic> currentItems;
  ResetImageLoadingState(this.currentItems);
}

class SyncFromYandexEvent extends StorageListEvent {
  final String path;

  SyncFromYandexEvent({required this.path});
}

class SyncToYandexEvent extends StorageListEvent {
  final String path;

  SyncToYandexEvent({required this.path});
}

class DeleteFolderEvent extends StorageListEvent {
  final String folderName;
  final String currentPath;

  DeleteFolderEvent({
    required this.folderName,
    required this.currentPath,
  });
}

class SyncAllEvent extends StorageListEvent {
  final String path;
  SyncAllEvent({required this.path});
}
