import '../features/folder/view/view.dart';
import '../features/storage_main/view/view.dart';

final routes = {
        '/': (context) => StorageListScreen(title: 'server'),
        '/file': (context) => FileScreen(folderName: 'Участок 1', imageCount: 30),
};