import 'package:autoexplorer/features/login/view/view.dart';

import '../features/storage/view/view.dart';

final routes = {
        '/': (context) => LoginScreen(),
        '/file': (context) => StorageListScreen(title: 'Участок 1'),
        '/storage': (context) => StorageListScreen(title: 'Серверное хранилище')
};