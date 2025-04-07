import 'dart:io';
import 'package:autoexplorer/repositories/storage/models/fileItem.dart';
import 'package:autoexplorer/repositories/storage/models/folder.dart';
import 'package:path/path.dart' as p;
import 'package:autoexplorer/repositories/storage/abstract_storage_repository.dart';
import 'package:path_provider/path_provider.dart';

class LocalRepository extends AbstractStorageRepository {
  @override
  Future<void> createFolder(
      {required String name, required String path}) async {
    final dir = await getAppDirectory();
    String finalpath;

    print('📦 Base dir for path="$path": ${dir.path}');
    if (path != '/') {
      finalpath = p.join(path, name);
    } else {
      finalpath = p.join(dir.path, name);
    }
    print(finalpath);
    final folder = Directory(finalpath);
    print('📁 Will create folder at: ${folder.path}');
    if (!(await folder.exists())) {
      await folder.create(recursive: true);
    }
  }

  @override
  Future<List> getFileAndFolderModels({String path = 'applicationData'}) async {
    final dir = await getAppDirectory(path: path);
    final List<dynamic> folderItems = [];

    // Получаем список всех элементов в директории
    final dirList = await dir.list().toList();

    for (var entity in dirList) {
      final name = p.basename(entity.path);
      if (entity is Directory) {
        // Если это папка, подсчитываем количество файлов в ней
        final filesCount = await _getFilesCountInDirectory(entity.path);
        folderItems.add(FolderItem(
          name: name,
          filesCount: filesCount,
          path: entity.path,
        ));
      } else if (entity is File) {
        final stat = await entity.stat();
        final creationDate =
            stat.modified.toIso8601String(); // или .changed для создания

        folderItems.add(FileItem(
          name: name,
          creationDate: creationDate,
          path: entity.path,
          imageURL: entity.path, // локальный путь как URL
        ));
      }
    }

    return folderItems;
  }

  Future<int> _getFilesCountInDirectory(String path) async {
    final directory = Directory(path);
    final List<FileSystemEntity> entities = await directory.list().toList();

    int filesCount = 0;
    for (var entity in entities) {
      if (entity is File) {
        filesCount++;
      }
    }
    return filesCount;
  }

  @override
  Future<String> getImageDownloadUrl(String filePath) {
    // TODO: implement getImageDownloadUrl
    throw UnimplementedError();
  }

  @override
  Future<void> uploadFile(
      {required String filePath, required String uploadPath}) async {
    try {
      final appDir = await getAppDirectory();

      // Полный путь назначения внутри applicationData
      final destinationPath = p.join(appDir.path, uploadPath);

      final destinationFile = File(destinationPath);
      await destinationFile.create(recursive: true);

      final sourceFile = File(filePath);
      await sourceFile.copy(destinationFile.path);
    } catch (e) {
      throw Exception('Failed to save file locally: $e');
    }
  }

  Future<Directory> getAppDirectory({String? path}) async {
    final baseDir = await getApplicationDocumentsDirectory();
    if (path == '/') path = null;
    final appDir =
        Directory(p.join(baseDir.path, 'applicationData', path ?? ''));

    if (!(await appDir.exists())) {
      await appDir.create(recursive: true);
    }

    return appDir;
  }
}
