import 'package:autoexplorer/repositories/storage/abstract_storage_repository.dart';
import 'package:autoexplorer/repositories/storage/storage_repository.dart';
import 'package:autoexplorer/repositories/users/abstract_users_repository.dart';
import 'package:autoexplorer/repositories/users/users_repository.dart';
import 'package:autoexplorer/router/authGuard.dart';
import 'package:autoexplorer/router/router.dart';
import 'package:autoexplorer/theme/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final String token = 'token';
  final Dio dio = Dio(BaseOptions(
    baseUrl: 'https://cloud-api.yandex.net/v1/disk/resources',
    headers: {
      'Authorization': 'OAuth $token',
    },
  ));

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  GetIt.I.registerLazySingleton<AbstractStorageRepository>(
    () => StorageRepository(dio: dio),
  );

  GetIt.I.registerLazySingleton<AbstractUsersRepository>(
    () => UsersRepository(firestore: firestore)
  );
  GetIt.I.registerSingleton<String>(token, instanceName: "yandex_token");


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
      navigatorObservers: [AuthGuard()],
      navigatorKey: navigatorKey,
      initialRoute: '/',
    );
  }
}
