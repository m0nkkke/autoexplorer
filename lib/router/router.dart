import 'package:autoexplorer/features/access/view/userkey_create_screen.dart';
import 'package:autoexplorer/features/access/view/userkey_info_screen.dart';
import 'package:autoexplorer/features/admin/view/admin_panel_screen.dart';
import 'package:autoexplorer/features/login/view/view.dart';
import 'package:autoexplorer/features/storage/bloc/storage_list_bloc.dart';
import 'package:autoexplorer/features/storage/view/image_view_screen.dart';
import 'package:autoexplorer/repositories/storage/abstract_storage_repository.dart';
import 'package:get_it/get_it.dart';
import '../features/storage/view/view.dart';

final routes = {
  '/': (context) => LoginScreen(),
  '/file': (context) => StorageListScreen(title: 'Участок 1'),
  '/storage': (context) => StorageListScreen(title: 'Серверное хранилище'),
  '/admin': (context) => AdminPanelScreen(),
  '/access': (context) => UserKeyInfoScreen(),
  '/access/create': (context) => UserKeyCreateScreen(),
  '/image_viewer': (context) => ImageViewerScreen(
        imageUrl: '',
        path: '',
        name: '',
        imageViewerBloc: StorageListBloc(GetIt.I<AbstractStorageRepository>()),
        currentItems: [],
      ),
};
