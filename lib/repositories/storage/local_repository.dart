import 'dart:convert';
import 'dart:io';
import 'package:autoexplorer/repositories/storage/models/fileItem.dart';
import 'package:autoexplorer/repositories/storage/models/file_json.dart';
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
    try {
      final dir = await getAppDirectory(
          path: path); // Используем вашу логику определения директории
      final List<ItemWrapper> wrapped = [];

      final entities = await dir.list().toList();

      // 1. Читаем локальный лог
      final logFile = await _getLogFile();
      final content = await logFile.readAsString();
      final List<dynamic> logEntriesJson = jsonDecode(content);
      final List<FileJSON> logEntries =
          logEntriesJson.map((json) => FileJSON.fromJson(json)).toList();

      for (final entity in entities) {
        final name = p.basename(entity.path);
        final stat = await entity.stat();
        final DateTime date = stat.modified;

        if (entity is Directory) {
          final filesCount = await _getFilesCountInDirectory(entity.path);
          // Для папок состояние синхронизации не отслеживается в этом сценарии
          wrapped.add(ItemWrapper(
            name: name,
            date: date,
            item: FolderItem(
              resourceId:
                  '', // Возможно, resourceId не нужен для локальных папок
              name: name,
              filesCount: filesCount,
              path: entity
                  .path, // Сохраняем относительный путь// Добавляем creationDate
              // isSynced не добавляем для FolderItem
            ),
          ));
        } else if (entity is File) {
          // 2. Проверяем состояние синхронизации для текущего файла
          final matchingLogEntry = logEntries.firstWhereOrNull((entry) =>
              entry.uploadPath == entity.path); // Ищем по relativePath

          // Если найдена запись в логе с isSynced == true, или если записи нет в логе,
          // считаем файл синхронизированным. Иначе - несинхронизированным.
          final isSynced = matchingLogEntry?.isSynced ?? true;

          wrapped.add(ItemWrapper(
            name: name,
            date: date,
            item: FileItem(
              name: name,
              creationDate: date.toIso8601String(),
              path: entity.path, // Сохраняем относительный путь
              imageURL:
                  entity.path, // Возможно, imageURL должен быть локальным путем
              isSynced: isSynced, // Передаем состояние синхронизации
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
    } catch (e) {
      print('Ошибка в LocalRepository.getFileAndFolderModels: $e');
      return [];
    }
  }

  // Добавляем метод для получения лог-файла
  Future<File> _getLogFile() async {
    final baseDir = await getApplicationDocumentsDirectory();
    final logFile = File(p.join(baseDir.path, 'createLog.json'));
    if (!await logFile.exists()) {
      await logFile.create(recursive: true);
      await logFile.writeAsString('[]', flush: true);
    }
    return logFile;
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

extension ListExtension<T> on List<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (var element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}
