import 'package:autoexplorer/features/access/view/userkey_create_screen.dart';
import 'package:autoexplorer/features/access/view/userkey_info_screen.dart';
import 'package:autoexplorer/features/admin/view/admin_panel_screen.dart';
import 'package:autoexplorer/features/login/view/view.dart';

import '../features/storage/view/view.dart';

final routes = {
        '/': (context) => LoginScreen(),
        '/file': (context) => StorageListScreen(title: 'Участок 1'),
        '/storage': (context) => StorageListScreen(title: 'Серверное хранилище'),
        '/admin': (context) => AdminPanelScreen(),
        '/access': (context) => UserKeyInfoScreen(),
        '/access/create': (context) => UserKeyCreateScreen(),
};