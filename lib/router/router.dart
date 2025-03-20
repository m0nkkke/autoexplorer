import 'package:autoexplorer/features/login/view/view.dart';

import '../features/storage/view/view.dart';

final routes = {
        '/': (context) => StorageListScreen(title: 'Серверное хранилище'),
        '/file': (context) => StorageListScreen(title: 'Участок 1'),
        '/login': (context) => LoginScreen()
};