import 'package:autoexplorer/connectivityService.dart';
import 'package:autoexplorer/features/storage/bloc/storage_list_bloc.dart';
import 'package:autoexplorer/generated/l10n.dart';
import 'package:autoexplorer/repositories/notifications/abstract_notifications_repository.dart';
import 'package:autoexplorer/repositories/notifications/notifications_repository.dart';
import 'package:autoexplorer/repositories/storage/abstract_storage_repository.dart';
import 'package:autoexplorer/repositories/storage/local_repository.dart';
import 'package:autoexplorer/repositories/storage/storage_repository.dart';
import 'package:autoexplorer/repositories/users/abstract_users_repository.dart';
import 'package:autoexplorer/repositories/users/users_repository.dart';
import 'package:autoexplorer/router/authGuard.dart';
import 'package:autoexplorer/router/router.dart';
import 'package:autoexplorer/theme/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';

/// Вспомогательный класс для «магических» констант и lazy-инициализации
class _AppConfig {
  static const _yandexBaseUrl =
      'https://cloud-api.yandex.net/v1/disk/resources';

  /// Загруженный из .env токен
  static String get yandexToken => dotenv.env['YANDEX_DISK_TOKEN'] ?? '';

  /// Настроенный Dio для Yandex API
  static Dio get yandexDio => Dio(BaseOptions(
        baseUrl: _yandexBaseUrl,
        headers: {'Authorization': 'OAuth ${yandexToken}'},
      ));
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Загрузить .env
  await dotenv.load();

  // 2. Инициализация Firebase
  await Firebase.initializeApp();

  // 3. Регистрация зависимостей
  _registerDependencies();

  // 4. Запуск приложения
  runApp(const AutoExplorerApp());
}

/// Регистрация всех зависимостей через GetIt
void _registerDependencies() {
  final getIt = GetIt.I;

  // Конфигурация и утилиты
  getIt
    ..registerSingleton<String>(
      _AppConfig.yandexToken,
      instanceName: 'yandex_token',
    )
    ..registerSingleton<Dio>(
      _AppConfig.yandexDio,
      instanceName: 'yandex_dio',
    )
    ..registerSingleton<ConnectivityService>(
      ConnectivityService(),
    );

  // Репозитории
  getIt
    ..registerLazySingleton<AbstractStorageRepository>(
      () => StorageRepository(
        dio: getIt<Dio>(instanceName: 'yandex_dio'),
      ),
      instanceName: 'yandex_repository',
    )
    ..registerLazySingleton<AbstractStorageRepository>(
      () => LocalRepository(),
      instanceName: 'local_repository',
    )
    ..registerLazySingleton<AbstractUsersRepository>(
      () => UsersRepository(firestore: FirebaseFirestore.instance),
    )
    ..registerLazySingleton<NotificationsRepositoryI>(
      () => NotificationsRepository(
        localNotifications: FlutterLocalNotificationsPlugin(),
        firebaseMessaging: FirebaseMessaging.instance,
      ),
    );

  // BLoC
  getIt.registerSingleton<StorageListBloc>(StorageListBloc());
}

class AutoExplorerApp extends StatelessWidget {
  const AutoExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AutoExplorer',
      theme: mainTheme,
      initialRoute: '/',
      routes: routes,
      navigatorKey: navigatorKey,
      navigatorObservers: [AuthGuard()],
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: Locale('ru'),
      supportedLocales: S.delegate.supportedLocales,
    );
  }
}
