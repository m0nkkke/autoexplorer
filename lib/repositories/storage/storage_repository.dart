import 'dart:io';
import 'package:autoexplorer/repositories/storage/local_repository.dart';
import 'package:autoexplorer/repositories/storage/models/disk_capacity.dart';
import 'package:autoexplorer/repositories/storage/models/disk_stat.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart' as p;
import 'package:autoexplorer/repositories/storage/abstract_storage_repository.dart';
import 'package:autoexplorer/repositories/storage/models/fileItem.dart';
import 'package:autoexplorer/repositories/storage/models/folder.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class StorageRepository extends AbstractStorageRepository {
  /// для работы с /v1/disk/resources
  final Dio dio;
  /// для работы с /v1/disk
  final Dio dioDisk;

  StorageRepository({ required this.dio })
    : dioDisk = Dio(BaseOptions(
        // тот же токен и заголовки, что и у dio
        headers: dio.options.headers,
        baseUrl: 'https://cloud-api.yandex.net/v1/disk',
      ));

  Future<List<dynamic>> getFileList({String path = '/'}) async {
    try {
      print('====================================');
      print('=====getFileList========');
      print('====================================');
      print('path: $path');
      print('====================================');

      final response = await dio.get('', queryParameters: {
        'path': path,
        // 'limit': 1000,
      });
      if (response.statusCode == 200) {
        print('Изображений: ${response.data['total']}');
        print(response.data['_embedded']['items']);
        return response.data['_embedded']['items'];
      } else {
        throw Exception('Failed to load FileItems: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load FileItems: $e');
    }
  }

  FileItem _mapFileItem(Map<String, dynamic> data) {
    final name = data['name'] ?? '';
    final creationDate = data['created'] ?? '';
    final path = data['path'] ?? '';
    String imageURL = '-'; // Значение по умолчанию

    // Для изображений пытаемся получить превью
    if (data['sizes'] != null && (data['sizes'] as List).isNotEmpty) {
      if (data['sizes'].length > 9) {
        imageURL = data['sizes'][8]['url'];
      } else {
        imageURL = data['sizes'][0]['url'] ?? '-';
      }
    }

    return FileItem(
      name: name,
      creationDate: creationDate,
      path: path,
      imageURL: imageURL,
    );
  }

  Future<FolderItem> _mapFolderItem(Map<String, dynamic> data) async {
    final path = data['path'] ?? '';
    final name = data['name'] ?? '';

    // Убираем disk:/ из имени папки
    final cleanName = name.replaceFirst('disk:/', '');

    try {
      final response = await dio.get('', queryParameters: {'path': path});
      final filesCount = response.data['_embedded']['total'] ?? 0;
      final resourceId = response.data['resource_id'] ?? '';

      return FolderItem(
        name: cleanName,
        filesCount: filesCount,
        path: path.replaceFirst('disk:/', ''), 
        resourceId: resourceId,
      );
    } catch (e) {
      debugPrint('⚠️ Ошибка получения информации о папке: $e');
      return FolderItem(
        name: cleanName,
        filesCount: 0,
        path: path.replaceFirst('disk:/', ''), 
        resourceId: 'missing',
      );
    }
  }

  @override
  Future<String> getImageDownloadUrl(String filePath) async {
    final response =
        await dio.get('/download', queryParameters: {'path': filePath});
    debugPrint(response.data.toString());
    return response.data['href']; // Временная ссылка
  }

  @override
  Future<List<dynamic>> getFileAndFolderModels({String path = 'disk:/'}) async {
    try {
      // Убедимся, что путь начинается с disk:/
      final cleanPath = path.startsWith('disk:/') ? path : 'disk:/$path';

      final response = await dio.get('', queryParameters: {'path': cleanPath});

      if (response.statusCode == 200) {
        final items = response.data['_embedded']['items'];
        final result = <dynamic>[];

        for (var item in items) {
          if (item['type'] == 'file') {
            result.add(_mapFileItem(item));
          } else if (item['type'] == 'dir') {
            result.add(await _mapFolderItem(item));
          }
        }
        return result;
      }
      throw Exception('Failed to load items');
    } catch (e) {
      debugPrint('❌ Ошибка получения списка файлов: $e');
      rethrow;
    }
  }

  // @override
  // Future<void> createFolder({
  //   required String name,
  //   required String path,
  // }) async {
  //   try {
  //     String fullPath;

  //     // Формируем полный путь
  //     if (path != '/' && path != 'disk:/') {
  //       fullPath = '$path/$name';
  //     } else {
  //       fullPath = 'disk:/$name';
  //     }

  //     // Проверяем, существует ли папка
  //     final exists = await checkIfFolderExistsOnYandex(fullPath);
  //     if (exists) {
  //       debugPrint('Папка уже существует: $fullPath');
  //       return;
  //     }

  //     // Создаём папку, если её нет
  //     final response = await dio.put('', queryParameters: {'path': fullPath});

  //     if (response.statusCode == 201) {
  //       debugPrint('✅ Папка создана: $fullPath');
  //     } else {
  //       throw Exception('Ошибка создания папки: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     debugPrint('❌ Ошибка при создании папки: $e');
  //     rethrow;
  //   }
  // }
  @override
  Future<void> createFolder({
    required String name,
    required String path, // что‑то вроде "/" или "/Test999"
  }) async {
    // 1) Собираем чистый POSIX‑путь: "/Test999/666" или "/444" для корня
    final fullPath = p.join(path, name);

    try {
      // 2) Отправляем запрос без дополнительного кодирования
      final response = await dio.put(
        '',
        queryParameters: {'path': fullPath},
      );

      // 3) 201 — создано, 409 — уже есть (тоже ок)
      if (response.statusCode == 201 || response.statusCode == 409) {
        debugPrint('✅ Папка создана: $fullPath');
      } else {
        debugPrint('⚠️ Unexpected status ${response.statusCode}: $fullPath');
      }
    } on DioException catch (e) {
      debugPrint('❌ Ошибка при создании папки: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<void> uploadFile({
    required String filePath,
    required String uploadPath,
  }) async {
    try {
      // Нормализуем путь (убираем 'disk:/' если есть)
      final cleanPath = uploadPath.replaceFirst('disk:/', '');

      // 1. Получаем URL для загрузки с флагом перезаписи
      final uploadUrlResponse = await dio.get(
        '/upload',
        queryParameters: {
          'path': cleanPath,
          'overwrite': 'true', // Разрешаем перезапись
        },
      );

      if (uploadUrlResponse.statusCode != 200) {
        throw Exception(
            'Не удалось получить URL для загрузки: ${uploadUrlResponse.statusCode}');
      }

      final uploadUrl = uploadUrlResponse.data['href'];

      // 2. Загружаем файл с явным указанием перезаписи
      final file = File(filePath);
      final uploadResponse = await dio.put(
        uploadUrl,
        data: await file.readAsBytes(),
        options: Options(
          headers: {
            'Content-Type': 'application/octet-stream',
            'Content-Length': (await file.stat()).size,
          },
        ),
      );

      if (uploadResponse.statusCode != 201) {
        throw Exception('Ошибка загрузки: ${uploadResponse.statusCode}');
      }

      debugPrint('✅ Файл загружен: $cleanPath');
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        debugPrint('⚠️ Файл уже существует: $uploadPath');
        return; // Пропускаем существующие файлы
      }
      debugPrint('❌ Ошибка загрузки файла ($uploadPath): ${e.message}');
      rethrow;
    }
  }

  Future<void> syncFromYandexDisk() async {
    try {
      final yandexFiles = await getFileAndFolderModels(path: 'disk:/');
      debugPrint('Получено элементов с Яндекс.Диска: ${yandexFiles.length}');

      final locRepo =
          GetIt.I<AbstractStorageRepository>(instanceName: 'local_repository');
      if (locRepo is LocalRepository) {
        final localDir = await locRepo.getAppDirectory(path: '/');

        // Удаляем старую папку disk: если она есть
        final oldDiskDir = Directory(p.join(localDir.path, 'disk:'));
        if (await oldDiskDir.exists()) {
          await oldDiskDir.delete(recursive: true);
        }

        // Синхронизируем каждый элемент
        for (var item in yandexFiles) {
          if (item is FolderItem) {
            await _syncYandexFolder(item, localDir);
          } else if (item is FileItem) {
            await _syncYandexFile(item, localDir);
          }
        }
      }
    } catch (e) {
      debugPrint('❌ Ошибка синхронизации с Яндекс.Диском: $e');
      rethrow;
    }
  }

  Future<void> _syncYandexFolder(FolderItem folder, Directory localRoot) async {
    final localPath = p.join(localRoot.path, folder.name);
    final localFolder = Directory(localPath);

    if (!(await localFolder.exists())) {
      await localFolder.create(recursive: true);
      debugPrint('📁 Создана папка: $localPath');
    }

    // Рекурсивно синхронизируем содержимое папки
    final nestedItems = await getFileAndFolderModels(path: folder.path);
    for (var item in nestedItems) {
      if (item is FolderItem) {
        await _syncYandexFolder(item, localFolder);
      } else if (item is FileItem) {
        await _syncYandexFile(item, localFolder);
      }
    }
  }

  Future<void> _syncYandexFile(FileItem file, Directory localDir) async {
    final localFilePath = p.join(localDir.path, file.name);
    final localFile = File(localFilePath);

    if (!(await localFile.exists())) {
      await downloadFileFromYandex(file, localFilePath);
      debugPrint('⬇️ Загружен файл: $localFilePath');
    }
  }

  Future<void> downloadFileFromYandex(
      FileItem fileItem, String localPath) async {
    final downloadUrl = await getImageDownloadUrl(fileItem.path);
    final response = await Dio()
        .get(downloadUrl, options: Options(responseType: ResponseType.bytes));
    final file = File(localPath);
    await file.writeAsBytes(response.data);
  }

  Future<bool> checkIfFolderExistsOnYandex(String path) async {
    try {
      final response = await dio.get(
        '',
        queryParameters: {'path': path},
      );
      return response.statusCode == 200;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return false; // Папки нет
      }
      rethrow; // Другие ошибки (например, 403, 500)
    }
  }

  Future<void> createFolderOnYandex(
      Directory localFolder, String yandexFolderPath) async {
    // имя локальной папки — это basename
    final folderName = p.basename(localFolder.path);
    // родительский путь на Диске — dirname или "/" если это корень
    var parentPath = p.dirname(yandexFolderPath);
    if (parentPath == '.' || parentPath.isEmpty) parentPath = '/';
    await createFolder(name: folderName, path: parentPath);
    debugPrint('📁 Папка создана на Яндекс.Диске: $parentPath/$folderName');
  }

  /// Основной метод «локал → яндекс»
  Future<void> syncToYandexDisk() async {
    final locRepo = GetIt.I<AbstractStorageRepository>(
      instanceName: 'local_repository',
    ) as LocalRepository;

    final localRoot = await locRepo.getAppDirectory(path: '/');
    // начинаем с корня Яндекс.Диска
    await _syncDirectoryToYandex(localRoot, 'disk:/');
  }

  static const _apiDelay = Duration(milliseconds: 300);
  Future<void> _syncDirectoryToYandex(
    Directory localDir,
    String remoteParentPath, // всегда вида 'disk:/...' без двойных слэшей
  ) async {
    final entities = await localDir.list().toList();
    for (final ent in entities) {
      final name = p.basename(ent.path);

      // строим полный путь: гарантируем ровно один слэш между parent и name
      final remoteFullPath = remoteParentPath.endsWith('/')
          ? '$remoteParentPath$name'
          : '$remoteParentPath/$name';

      if (ent is Directory) {
        debugPrint('📁 Проверка папки: $remoteFullPath');
        if (!await checkIfFolderExistsOnYandex(remoteFullPath)) {
          debugPrint('➕ Создаём папку: $remoteFullPath');
          await createFolder(name: name, path: remoteParentPath);
        }
        // и рекурсивно внутрь
        await _syncDirectoryToYandex(ent, remoteFullPath);
      } else if (ent is File) {
        // чуть притормозим, чтоб не получить 429
        await Future.delayed(_apiDelay);

        debugPrint('📄 Проверка файла: $remoteFullPath');
        if (!await checkIfFileExistsOnYandex(remoteFullPath)) {
          debugPrint('⬆️ Заливаем файл: ${ent.path} → $remoteFullPath');
          await uploadFile(
            filePath: ent.path,
            uploadPath: remoteFullPath,
          );
        }
      }
    }
  }

  Future<void> uploadFileToYandex(File localFile, String yandexFilePath) async {
    // Убираем префикс "disk:" из пути перед загрузкой
    final cleanYandexPath = yandexFilePath.replaceFirst('disk:', '');

    await uploadFile(filePath: localFile.path, uploadPath: cleanYandexPath);
  }

  Future<bool> checkIfFileExistsOnYandex(String path) async {
    try {
      final response = await dio.get(
        '',
        queryParameters: {'path': path.replaceFirst('disk:/', '')},
      );
      return response.statusCode == 200 && response.data['type'] == 'file';
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return false;
      }
      debugPrint('⚠️ Ошибка проверки файла: ${e.message}');
      return true; // В случае ошибки считаем что файл существует
    }
  }

  @override
  Future<void> syncAll({String path = '/'}) async {
    // 1) «Яндекс → локаль»
    await syncFromYandexDisk();
    // 2) «Локаль → Яндекс»
    await syncToYandexDisk();
  }

 /// 1) Получаем общий объём и занятый объём
  Future<DiskCapacity> getCapacity() async {
    final resp = await dioDisk.get('/'); // GET https://.../v1/disk/
    if (resp.statusCode == 200) {
      final data = resp.data;
      final total = (data['total_space'] as num).toDouble();
      final used  = (data['used_space']  as num).toDouble();
      return DiskCapacity(
        total / (1024*1024*1024),
        used  / (1024*1024*1024),
      );
    }
    throw Exception('Capacity error: ${resp.statusCode}');
  }

  /// 2) Считаем папки в корне и все изображения на диске
  Future<DiskStats> getDiskStats() async {
    // 2.2) общее число изображений
    final resp = await dio.get(
      '/files', // baseUrl у dio = .../v1/disk/resources
      queryParameters: {
        'media_type': 'image',
        'limit': 99999,
      },
    );
    if (resp.statusCode == 200) {
      final totalImages = resp.data['items'].length as int;
      return DiskStats(totalImages);
    }
    throw Exception('Files stats error: ${resp.statusCode}');
  }
}
