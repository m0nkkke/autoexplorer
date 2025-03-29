import 'package:autoexplorer/repositories/storage/abstract_storage_repository.dart';
import 'package:autoexplorer/repositories/storage/models/fileItem.dart';
import 'package:autoexplorer/repositories/storage/models/folder.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class StorageRepository extends AbstractStorageRepository {
  static const String token =
      'OAuth TOKEN';
  final Dio dio = Dio(BaseOptions(
    baseUrl: 'https://cloud-api.yandex.net/v1/disk/resources',
    headers: {
      'Authorization': token,
    },
  ));
  final Dio dioDownload = Dio(BaseOptions(
    baseUrl: 'https://cloud-api.yandex.net/v1/disk/resources/download',
    headers: {
      'Authorization': token,
    },
  ));

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
        await dioDownload.get('', queryParameters: {'path': filePath});
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
}