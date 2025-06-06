import 'package:autoexplorer/features/access/view/userkey_create_provider.dart';
import 'package:autoexplorer/features/access/view/userkey_info_screen.dart';
import 'package:autoexplorer/features/admin/view/admin_panel_screen.dart';
import 'package:autoexplorer/features/login/view/view.dart';
import 'package:autoexplorer/features/storage/bloc/storage_list_bloc.dart';
import 'package:autoexplorer/features/storage/view/image_view_screen.dart';
import 'package:flutter/material.dart';
import '../features/storage/view/view.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final routes = {
  '/': (context) => LoginScreen(),
  '/file': (context) => StorageListScreen(title: 'Участок'),
  '/storage': (context) => StorageListScreen(title: 'Серверное хранилище'),
  '/admin': (context) => AdminPanelScreen(),
  '/access': (context) => UserKeyInfoScreen(),
  '/access/create': (context) => UserKeyCreateProvider(),
  '/image_viewer': (context) => ImageViewerScreen(
        imageUrl: '',
        path: '',
        name: '',
        imageViewerBloc: StorageListBloc(),
        currentItems: [],
      ),
};
