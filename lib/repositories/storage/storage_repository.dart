import 'package:autoexplorer/repositories/storage/models/fileItem.dart';
import 'package:autoexplorer/repositories/storage/models/folder.dart';
import 'package:dio/dio.dart';

class StorageRepository {
  final Dio dio = Dio(BaseOptions(
    baseUrl: 'https://cloud-api.yandex.net/v1/disk/resources',
    headers: {
      'Authorization': 'OAuth TOKEN',
    },
  ));

  Future<List<dynamic>> getFileList({String path = '/'}) async {
    try {
      final response = await dio.get('', queryParameters: {'path': path});
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

  Future<List<dynamic>> getFilesAndFoldersModels({String path = '/'}) async {
    try {
      final response = await dio.get('', queryParameters: {'path': path});
      if (response.statusCode == 200) {
        print('Loading data...');
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
    return FileItem(
      name: data['name'] ?? '',
      creationDate: data['created'] ?? '',
      path: data['path'] ?? '',
    );
  }

  FolderItem _mapFolderItem(Map<String, dynamic> data) {
    return FolderItem(
      name: data['name'] ?? '',
      filesCount: 0, // Невозможно получить точное число файлов в папке из этого запроса
      path: data['path'] ?? '',
    );
  }

  Future<List<dynamic>> getFileAndFolderModels({String path = '/'}) async {
    try {
      final items = await getFilesAndFoldersModels(path: path);
      List<dynamic> result = [];
      for (var item in items) {
        if (item['type'] == 'file') {
          result.add(_mapFileItem(item));
        } else if (item['type'] == 'dir') {
          result.add(_mapFolderItem(item));
        }
      }
      return result;
    } catch (e) {
      throw Exception('Failed to load FileItems: $e');
    }
  }
}