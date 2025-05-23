import 'dart:io';

import 'package:autoexplorer/repositories/storage/abstract_storage_repository.dart';
import 'package:autoexplorer/repositories/storage/models/fileItem.dart';
import 'package:autoexplorer/repositories/storage/models/folder.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class StorageRepository extends AbstractStorageRepository {
  StorageRepository({required this.dio});

  final Dio dio;

  Future<List<dynamic>> getFileList({String path = '/'}) async {
    try {
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
    // debugPrint('=========data of $name========');
    // debugPrint(data['sizes'].length.toString());
    // for (int i = 0; i < data['sizes'].length; i++) {
    //   debugPrint(data['sizes'][i].toString());
    // }

    return FileItem(
      name: name,
      creationDate: creationDate,
      path: path,
      imageURL: imageURL,
    );
  }

  Future<FolderItem> _mapFolderItem(Map<String, dynamic> data) async {
    final path = data['path'];
    int filesCount = 0;
    final name = data['name'];
    final resourceId = data['resource_id'];
    try {
      final response = await dio.get('', queryParameters: {'path': path});
      filesCount = response.data['_embedded']['total'];
      debugPrint(' ${filesCount.toString()}');
    } catch (e) {
      debugPrint(e.toString());
    }
    return FolderItem(
      resourceId: resourceId ?? '',
      name: name ?? '',
      filesCount: filesCount,
      // 0, // Невозможно получить точное число файлов в папке из этого запроса
      path: path ?? '',
    );
  }

  @override
  Future<String> getImageDownloadUrl(String filePath) async {
    final response =
        await dio.get('/download', queryParameters: {'path': filePath});
    debugPrint(response.data.toString());
    return response.data['href']; // Временная ссылка
  }

  @override
  Future<List<dynamic>> getFileAndFolderModels({String path = '/'}) async {
    try {
      final response = await dio.get('', queryParameters: {'path': path});
      List<dynamic> result = [];

      if (response.statusCode == 200) {
        print('Loading data...');
        debugPrint('Public key: ${response.data['resource_id'].toString()}');

        final items = response.data['_embedded']['items'];

        // Проходим по всем элементам и добавляем их в результат
        for (var item in items) {
          if (item['type'] == 'file') {
            result.add(_mapFileItem(item)); // Добавляем файл
          } else if (item['type'] == 'dir') {
            result.add(await _mapFolderItem(item)); // Добавляем папку
          }
        }

        return result;
      }

      throw Exception('Failed to load FileItems');
    } catch (e) {
      throw Exception('Failed to load FileItems: $e');
    }
  }


  @override
  Future<void> createFolder(
      {required String name, required String path}) async {
    try {
      String fullpath;
      if (path != '/' && path != 'disk:/') {
        fullpath = '$path/$name';
      } else {
        fullpath = 'disk:/$name';
      }
      // final encodedPath = Uri.encodeComponent(fullpath);
      final response = await dio.put('', queryParameters: {'path': fullpath});

      if (response.statusCode == 201) {
        debugPrint('good create');
      } else {
        throw Exception('Error create folder');
      }
    } catch (e) {
      throw Exception('Error create folder - $e');
    }
  }

  @override
  Future<void> uploadFile({
    required String filePath,
    required String uploadPath,
  }) async {
    try {
      // 1. Получаем URL для загрузки
      final uploadUrlResponse = await dio.get(
        '/upload',
        queryParameters: {
          'path': uploadPath,
          'overwrite': 'true',
        },
      );

      final uploadUrl = uploadUrlResponse.data['href'];

      // 2. Загружаем файл по полученному URL
      final file = File(filePath);
      final fileBytes = await file.readAsBytes();

      final uploadResponse = await dio.put(
        uploadUrl,
        data: Stream.fromIterable([fileBytes]),
        options: Options(
          headers: {
            'Content-Type': 'application/octet-stream',
            'Content-Length': fileBytes.length,
          },
        ),
      );

      if (uploadResponse.statusCode != 201) {
        throw Exception('Failed to upload file: ${uploadResponse.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }
  
}
