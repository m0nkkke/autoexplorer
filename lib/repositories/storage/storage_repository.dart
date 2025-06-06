import 'dart:convert';
import 'dart:io';
import 'package:autoexplorer/repositories/storage/local_repository.dart';
import 'package:autoexplorer/repositories/storage/models/disk_capacity.dart';
import 'package:autoexplorer/repositories/storage/models/disk_stat.dart';
import 'package:autoexplorer/repositories/storage/models/item_wrapper.dart';
import 'package:autoexplorer/repositories/storage/models/sortby.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:autoexplorer/repositories/storage/abstract_storage_repository.dart';
import 'package:autoexplorer/repositories/storage/models/fileItem.dart';
import 'package:autoexplorer/repositories/storage/models/folder.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class StorageRepository extends AbstractStorageRepository {
  /// для работы с /v1/disk/resources
  final Dio dio;

  /// для работы с /v1/disk
  final Dio dioDisk;

  StorageRepository({required this.dio})
      : dioDisk = Dio(BaseOptions(
          // тот же токен и заголовки, что и у dio
          headers: dio.options.headers,
          baseUrl: 'https://cloud-api.yandex.net/v1/disk',
        ));

  Future<List<dynamic>> getFileList({String path = '/'}) async {
    try {
      final response = await dio.get('', queryParameters: {
        'path': path,
      });
      if (response.statusCode == 200) {
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
    return response.data['href'];
  }

  /// принимает:
  ///  - [searchQuery] — если не null/пусто, то фильтрует по вхождению в название
  ///  - [sortBy] — SortBy.name или SortBy.date
  ///  - [ascending] — true = по возрастанию, false = по убыванию
  @override
  Future<List<dynamic>> getFileAndFolderModels({
    String path = 'disk:/',
    String? searchQuery,
    SortBy sortBy = SortBy.name,
    bool ascending = true,
  }) async {
    try {
      final cleanPath = path.startsWith('disk:/') ? path : 'disk:/$path';
      final response = await dio.get(
        '',
        queryParameters: {'path': cleanPath},
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to load items from Yandex: ${response.statusCode}');
      }

      final items = response.data['_embedded']['items'] as List<dynamic>;

      // 1) Заворачиваем все в промежуточные объекты с именем и датой
      final List<ItemWrapper> wrapped = [];
      for (final raw in items) {
        final type = raw['type'] as String;
        final name = raw['name'] as String;
        final dateString =
            raw['created'] as String? ?? raw['modified'] as String;
        final date = DateTime.parse(dateString);

        final dynamic model =
            (type == 'file') ? _mapFileItem(raw) : await _mapFolderItem(raw);

        wrapped.add(ItemWrapper(name: name, date: date, item: model));
      }

      // 2) Фильтрация
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final q = searchQuery.toLowerCase();
        wrapped.retainWhere((w) => w.name.toLowerCase().contains(q));
      }

      // 3) Сортировка
      wrapped.sort((a, b) {
        final cmp = (sortBy == SortBy.name)
            ? a.name.toLowerCase().compareTo(b.name.toLowerCase())
            : a.date.compareTo(b.date);
        return ascending ? cmp : -cmp;
      });

      // 4) Отворачиваем в чистый список моделей
      return wrapped.map((w) => w.item).toList();
    } catch (e) {
      debugPrint('❌ Ошибка получения списка с Яндекса: $e');
      rethrow;
    }
  }

  Future<String?> fetchRegionalFolderName(String regionalId) async {
    try {
      final allRootItems = await getFileAndFolderModels(
        path: 'disk:/',
      );
      for (final item in allRootItems) {
        if (item is FolderItem) {
          if (item.resourceId == regionalId) {
            return item.name;
          }
        }
      }
      return null;
    } catch (e) {
      debugPrint('Ошибка при загрузке корневых папок: $e');
      return null;
    }
  }

  @override

  /// 2) Метод создаёт папку [name] внутри POSIX-пути [path] (например, '/applicationData/РегионХ'),
  ///    затем проверяет, лежит ли она локально внутри <appDir>/<regionalName>. Если да – добавляет её resource_id
  ///    в accessList пользователя. Иначе – не меняет accessList.
  Future<void> createFolder({
    required String name,
    required String
        path, // например "/Регионал-ЭнергоКрас" или "/Регионал-ЭнергоКрас/новаяпапка"
  }) async {
    // 1) Узнаём uid и регион пользователя
    final fbUser = FirebaseAuth.instance.currentUser;
    if (fbUser == null) {
      throw StateError('Пользователь не авторизован');
    }
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(fbUser.uid)
        .get();
    final userData = userDoc.data();
    final regionalId = userData?['regional'] as String?;
    if (regionalId == null) {
      throw StateError('У пользователя нет поля "regional"');
    }

    // 2) Получаем локальный корневой каталог applicationData
    final localRepo =
        GetIt.I<AbstractStorageRepository>(instanceName: 'local_repository')
            as LocalRepository;
    final appDir = await localRepo.getAppDirectory(path: '/');

    // 3) Получаем имя папки-региона на Яндекс.Диске по resourceId
    final regionalName = await fetchRegionalFolderName(regionalId);
    if (regionalName == null) {
      debugPrint('Не найден регион с resourceId=$regionalId на Яндекс.Диске');
    }

    // 4) Формируем POSIX-путь для новой папки на Я.Диске
    //    если path="/Регионал-ЭнергоКрас", name="accessadded",
    //    то fullPath="/Регионал-ЭнергоКрас/accessadded"
    final fullPath = p.posix.join(path, name);

    try {
      // 5) Создаём папку на Яндекс.Диске
      final createResp = await dio.put(
        '',
        queryParameters: {'path': fullPath},
      );
      if (createResp.statusCode != 201 && createResp.statusCode != 409) {
        throw StateError(
            'Unexpected status ${createResp.statusCode} при создании папки $fullPath');
      }
      debugPrint('✅ Папка создана (или уже есть): $fullPath');

      // 6) Запрашиваем метаданные, чтобы получить resource_id
      final metaResp = await dio.get(
        '',
        queryParameters: {'path': fullPath},
      );
      if (metaResp.statusCode != 200) {
        throw StateError(
            'Не удалось получить метаданные для $fullPath: ${metaResp.statusCode}');
      }
      final metaData = metaResp.data as Map<String, dynamic>;
      final newResourceId = metaData['resource_id'] ?? metaData['resourceId'];
      if (newResourceId is! String) {
        throw StateError('Не удалось извлечь resource_id из ответа: $metaData');
      }

      // 7) Проверяем: создаём ли мы на прямом уровне региональной папки?
      //    То есть, только если path exactly == "/Регионал-ЭнергоКрас"
      if (regionalName != null && path == '/$regionalName') {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(fbUser.uid)
            .update({
          'accessList': FieldValue.arrayUnion([newResourceId]),
        });
        debugPrint(
            '🔑 $newResourceId добавлен в accessList пользователя ${fbUser.uid}');
      } else {
        debugPrint(
            'ℹ️ Папка $fullPath не создана на уровне "/$regionalName" — не меняем accessList');
      }
    } on DioException catch (e) {
      debugPrint('❌ Ошибка при создании папки: ${e.message}');
      rethrow;
    }
  }

  Future<Uint8List?> _compressImage(String filePath) =>
      FlutterImageCompress.compressWithFile(
        filePath,
        minWidth: 1024,
        minHeight: 768,
        quality: 80,
      );

  Future<File> get _syncFile async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'sync_status.json'));
    if (!await file.exists()) {
      await file.writeAsString(jsonEncode({}), flush: true);
    }
    return file;
  }

  Future<void> _markSyncedInJson(String localPath) async {
    final file = await _syncFile;
    final content = await file.readAsString();
    final Map<String, dynamic> data =
        content.isEmpty ? {} : jsonDecode(content) as Map<String, dynamic>;
    data[localPath] = true;
    await file.writeAsString(jsonEncode(data), flush: true);
  }

  @override
  Future<void> uploadFile({
    required String filePath,
    required String uploadPath,
  }) async {
    try {
      final cleanPath = uploadPath.replaceFirst('disk:/', '');

      // 1) Получаем ссылку на загрузку
      final urlResp = await dio.get(
        '/upload',
        queryParameters: {'path': cleanPath, 'overwrite': 'true'},
      );
      if (urlResp.statusCode != 200) {
        throw Exception('Не удалось получить URL: ${urlResp.statusCode}');
      }
      final uploadUrl = urlResp.data['href'] as String;

      // 2) Пытаемся сжать, если это изображение
      Uint8List data;
      if (['.jpg', '.jpeg', '.png']
          .any((ext) => filePath.toLowerCase().endsWith(ext))) {
        final compressed = await _compressImage(filePath);
        data = compressed ?? await File(filePath).readAsBytes();
      } else {
        data = await File(filePath).readAsBytes();
      }

      // 3) Загружаем
      final uploadResp = await dio.put(
        uploadUrl,
        data: data,
        options: Options(headers: {
          'Content-Type': 'application/octet-stream',
          'Content-Length': data.length,
        }),
      );
      if (uploadResp.statusCode != 201) {
        throw Exception('Ошибка загрузки: ${uploadResp.statusCode}');
      }
      final user = FirebaseAuth.instance.currentUser;
      final nowUtc = DateTime.now().toUtc();
      final mskTime = nowUtc.add(Duration(hours: 3));
      final formatter = DateFormat('dd-MM-yyyy HH:mm');
      final formatted = formatter.format(mskTime);
      final docRef =
          FirebaseFirestore.instance.collection('users').doc('${user?.uid}');
      await docRef.update({
        'lastUpload': formatted,
        'imagesCount': FieldValue.increment(1),
      });
      await _markSyncedInJson(filePath);
      debugPrint('✅ Загружено и сжато: $cleanPath');
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) return;
      debugPrint('❌ Ошибка: ${e.message}');
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
      rethrow; // Другие ошибки
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

  /// Основной метод «локал -> яндекс»
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
      final used = (data['used_space'] as num).toDouble();
      return DiskCapacity(
        total / (1024 * 1024 * 1024),
        used / (1024 * 1024 * 1024),
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

  Future<void> syncRegionalAndAreasStructure({
    required String userRegionalId,
    required List<String> accessList,
    required bool isAdmin,
  }) async {
    // 1) Получаем все “региональные” папки из корня
    final rootItems = await getFileAndFolderModels(path: 'disk:/');
    final allRegions = rootItems.whereType<FolderItem>().toList();

    // 2) Выбираем только те регионы, к которым есть доступ
    final allowedRegions = isAdmin
        ? []
        : allRegions.where((r) => r.resourceId == userRegionalId).toList();

    if (allowedRegions.isEmpty && !isAdmin) {
      throw Exception('Регион для пользователя не найден');
    }

    // 3) Берём локальный корень applicationData
    final localRepo =
        GetIt.I<AbstractStorageRepository>(instanceName: 'local_repository')
            as LocalRepository;
    final appDir = await localRepo.getAppDirectory(path: '/');

    // 4) Пробегаемся по каждому разрешённому региону
    for (final region in allowedRegions) {
      // 4.1) Создаём папку региона
      final regionLocalDir = Directory(p.join(appDir.path, region.name));
      if (!await regionLocalDir.exists()) {
        await regionLocalDir.create(recursive: true);
      }

      // 4.2) Запрашиваем вложенные элементы регионала
      final regionContents = await getFileAndFolderModels(path: region.path);

      // 4.3) Оставляем только папки-участки из accessList
      final allowedAreas = regionContents
          .whereType<FolderItem>()
          .where((area) => accessList.contains(area.resourceId))
          .toList();

      // 4.4) Создаём на диске **только** папки участков (без рекурсии!)
      for (final area in allowedAreas) {
        final areaDir = Directory(p.join(regionLocalDir.path, area.name));
        if (!await areaDir.exists()) {
          await areaDir.create(recursive: true);
        }
      }
    }
  }
}
