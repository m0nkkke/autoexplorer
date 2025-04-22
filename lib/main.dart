import 'package:autoexplorer/features/storage/bloc/storage_list_bloc.dart';
import 'package:autoexplorer/repositories/storage/abstract_storage_repository.dart';
import 'package:autoexplorer/repositories/storage/storage_repository.dart';
import 'package:autoexplorer/repositories/storage/local_repository.dart';
import 'package:autoexplorer/repositories/users/abstract_users_repository.dart';
import 'package:autoexplorer/repositories/users/users_repository.dart';
import 'package:autoexplorer/router/authGuard.dart';
import 'package:autoexplorer/router/router.dart';
import 'package:autoexplorer/theme/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); 
  print("te1");
  await dotenv.load();
  print("te");

  final String token = dotenv.env['YANDEX_DISK_TOKEN'] ?? 'DEFAULT';
  print(token);
  final Dio dio = Dio(BaseOptions(
    baseUrl: 'https://cloud-api.yandex.net/v1/disk/resources',
    headers: {
      'Authorization': 'OAuth $token',
    },
  ));

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  GetIt.I.registerLazySingleton<AbstractStorageRepository>(
    () => StorageRepository(dio: dio),
    instanceName: 'yandex_repository',
  );
  
  GetIt.I.registerLazySingleton<AbstractStorageRepository>(
    () => LocalRepository(),
    instanceName: 'local_repository',
  );

  GetIt.I.registerLazySingleton<AbstractUsersRepository>(
      () => UsersRepository(firestore: firestore));
  GetIt.I.registerSingleton<String>(token, instanceName: "yandex_token");

  GetIt.I.registerSingleton<StorageListBloc>(StorageListBloc());

  final storageListBloc = GetIt.I<StorageListBloc>();
  storageListBloc.add(SyncAllEvent(path: '/'));

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
