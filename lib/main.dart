import 'package:autoexplorer/repositories/storage/abstract_storage_repository.dart';
import 'package:autoexplorer/repositories/storage/storage_repository.dart';
import 'package:autoexplorer/router/router.dart';
import 'package:autoexplorer/theme/theme.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final String token = 'ТОКЕН';
  final Dio dio = Dio(BaseOptions(
    baseUrl: 'https://cloud-api.yandex.net/v1/disk/resources',
    headers: {
      'Authorization': 'OAuth $token',
    },
  ));

  GetIt.I.registerLazySingleton<AbstractStorageRepository>(
    () => StorageRepository(dio: dio),
  );

  runApp(const AutoExplorerApp());
}
class AutoExplorerApp extends StatelessWidget {
  const AutoExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AutoExplorer',
      theme: mainTheme,
      routes: routes,
    );
  }
}
