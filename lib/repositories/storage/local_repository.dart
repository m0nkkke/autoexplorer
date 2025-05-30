import 'dart:io';
import 'package:autoexplorer/repositories/storage/models/fileItem.dart';
import 'package:autoexplorer/repositories/storage/models/folder.dart';
import 'package:autoexplorer/repositories/storage/models/item_wrapper.dart';
import 'package:autoexplorer/repositories/storage/models/sortby.dart';
import 'package:path/path.dart' as p;
import 'package:autoexplorer/repositories/storage/abstract_storage_repository.dart';
import 'package:path_provider/path_provider.dart';

class LocalRepository extends AbstractStorageRepository {
  @override
  Future<void> createFolder(
      {required String name, required String path}) async {
    final dir = await getAppDirectory();
    String finalpath;

    if (path != '/') {
      finalpath = p.join(path, name);
    } else {
      finalpath = p.join(dir.path, name);
    }
    final folder = Directory(finalpath);
    if (!(await folder.exists())) {
      await folder.create(recursive: true);
    }
  }

  /// принимает:
  ///  - [searchQuery] — если не null/пусто, то фильтрует по вхождению в название
  ///  - [sortBy] — SortBy.name или SortBy.date
  ///  - [ascending] — true = по возрастанию, false = по убыванию
  @override
  Future<List<dynamic>> getFileAndFolderModels({
    String path = 'applicationData',
    String? searchQuery,
    SortBy sortBy = SortBy.name,
    bool ascending = true,
  }) async {
    final dir = await getAppDirectory(path: path);
    final List<ItemWrapper> wrapped = [];

    final entities = await dir.list().toList();
    for (final entity in entities) {
      final name = p.basename(entity.path);
      final stat = await entity.stat();
      final DateTime date = stat.modified;

      if (entity is Directory) {
        final filesCount = await _getFilesCountInDirectory(entity.path);
        wrapped.add(ItemWrapper(
          name: name,
          date: date,
          item: FolderItem(
            resourceId: '',
            name: name,
            filesCount: filesCount,
            path: entity.path,
          ),
        ));
      } else if (entity is File) {
        wrapped.add(ItemWrapper(
          name: name,
          date: date,
          item: FileItem(
            name: name,
            creationDate: date.toIso8601String(),
            path: entity.path,
            imageURL: entity.path,
          ),
        ));
      }
    }

    // 1) Фильтрация
    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase();
      wrapped.retainWhere((w) => w.name.toLowerCase().contains(q));
    }

    // 2) Сортировка
    wrapped.sort((a, b) {
      int cmp;
      if (sortBy == SortBy.name) {
        cmp = a.name.toLowerCase().compareTo(b.name.toLowerCase());
      } else {
        cmp = a.date.compareTo(b.date);
      }
      return ascending ? cmp : -cmp;
    });

    // 3) Отворачиваем обратно в модели
    return wrapped.map((w) => w.item).toList();
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

  @override
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

  Future<void> deleteFolder({
    required String name,
    required String path,
  }) async {
    try {
      final dir = await getAppDirectory(path: path);
      final entityPath = p.join(dir.path, name);

      // Проверяем файл
      final file = File(entityPath);
      if (await file.exists()) {
        await file.delete();
        return;
      }

      // Проверяем папку
      final folder = Directory(entityPath);
      if (await folder.exists()) {
        await folder.delete(recursive: true);
        return;
      }

      throw Exception('Файл или папка не существуют: \$entityPath');
    } catch (e) {
      rethrow;
    }
  }
}
