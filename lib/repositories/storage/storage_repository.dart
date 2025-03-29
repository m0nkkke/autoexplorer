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

  // Future<List<dynamic>> getFilesAndFoldersModels({String path = '/'}) async {
  //   try {
  //     final response = await dio.get('', queryParameters: {'path': path});
  //     if (response.statusCode == 200) {
  //       print('Loading data...');
  //       debugPrint(response.data['_embedded'].toString());
  //       debugPrint(response.data['_embedded']['total'].toString());
  //       return response.data['_embedded']['items'];
  //     } else {
  //       throw Exception('Failed to load FileItems: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to load FileItems: $e');
  //   }
  // }

  FileItem _mapFileItem(Map<String, dynamic> data) {
    final name = data['name'];
    final creationDate = data['created'];
    final path = data['path'];
    debugPrint(path);
    debugPrint(data['sizes'][0].toString());

    // final dataSizes = data['sizes'];
    // debugPrint(dataSizes);
    final imageURL = data['sizes'][0]['url'];
    // final imageURL = await getImageDownloadUrl(path);
    return FileItem(
      name: name ?? '',
      creationDate: creationDate ?? '',
      path: path ?? '',
      imageURL: imageURL ?? '',
    );
  }

  Future<FolderItem> _mapFolderItem(Map<String, dynamic> data) async {
    final path = data['path'];
    int filesCount = 0;
    final name = data['name'];
    try {
      final response = await dio.get('', queryParameters: {'path': path});
      filesCount = response.data['_embedded']['total'];
      debugPrint(' ${filesCount.toString()}');
    } catch (e) {
      debugPrint(e.toString());
    }
    return FolderItem(
      name: name ?? '',
      filesCount: filesCount,
      // 0, // Невозможно получить точное число файлов в папке из этого запроса
      path: path ?? '',
    );
  }

  Future<String> getImageDownloadUrl(String filePath) async {
    final response =
        await dio.get('/download', queryParameters: {'path': filePath});
    return response.data['href']; // Временная ссылка
  }

  @override
  Future<List<dynamic>> getFileAndFolderModels({String path = '/'}) async {
    try {
      final response = await dio.get('', queryParameters: {'path': path});
      List<dynamic> result = [];
      if (response.statusCode == 200) {
        print('Loading data...');
        debugPrint(response.data['_embedded'].toString());
        debugPrint(response.data['_embedded']['total'].toString());
        final items = response.data['_embedded']['items'];
        for (var item in items) {
          if (item['type'] == 'file') {
            result.add(_mapFileItem(item));
          } else if (item['type'] == 'dir') {
            result.add(await _mapFolderItem(item));
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
      final fullpath = '$path/$name';
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
}

