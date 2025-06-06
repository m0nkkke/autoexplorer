import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static FirebaseOptions web = FirebaseOptions(
    apiKey: dotenv.env['API_KEY_WEB'] ?? 'DEFAULT',
    appId: dotenv.env['APP_ID_WEB'] ?? 'DEFAULT',
    messagingSenderId: dotenv.env['MESSAGING_SENDER_ID'] ?? 'DEFAULT',
    projectId: dotenv.env['PROJECT_ID'] ?? 'DEFAULT',
    authDomain: dotenv.env['AUTH_DOMAIN'] ?? 'DEFAULT',
    storageBucket: dotenv.env['STORAGE_BUCKET'] ?? 'DEFAULT',
  );

  static FirebaseOptions android = FirebaseOptions(
    apiKey: dotenv.env['API_KEY_ANDROID'] ?? 'DEFAULT',
    appId: dotenv.env['APP_ID_ANDROID'] ?? 'DEFAULT',
    messagingSenderId: dotenv.env['MESSAGING_SENDER_ID'] ?? 'DEFAULT',
    projectId: dotenv.env['PROJECT_ID'] ?? 'DEFAULT',
    storageBucket: dotenv.env['STORAGE_BUCKET'] ?? 'DEFAULT',
  );

  static FirebaseOptions ios = FirebaseOptions(
    apiKey: dotenv.env['API_KEY_IOS'] ?? 'DEFAULT',
    appId: dotenv.env['APP_ID_IOS'] ?? 'DEFAULT',
    messagingSenderId: dotenv.env['MESSAGING_SENDER_ID'] ?? 'DEFAULT',
    projectId: dotenv.env['PROJECT_ID'] ?? 'DEFAULT',
    storageBucket: dotenv.env['STORAGE_BUCKET'] ?? 'DEFAULT',
    iosBundleId: dotenv.env['IOS_BUNDLE_ID'] ?? 'DEFAULT',
  );

  static FirebaseOptions macos = FirebaseOptions(
    apiKey: dotenv.env['API_KEY_IOS'] ?? 'DEFAULT',
    appId: dotenv.env['APP_ID_IOS'] ?? 'DEFAULT',
    messagingSenderId: dotenv.env['MESSAGING_SENDER_ID'] ?? 'DEFAULT',
    projectId: dotenv.env['PROJECT_ID'] ?? 'DEFAULT',
    storageBucket: dotenv.env['STORAGE_BUCKET'] ?? 'DEFAULT',
    iosBundleId: dotenv.env['IOS_BUNDLE_ID'] ?? 'DEFAULT',
  );

  static FirebaseOptions windows = FirebaseOptions(
    apiKey: dotenv.env['API_KEY_WEB'] ?? 'DEFAULT',
    appId: dotenv.env['APP_ID_WEB'] ?? 'DEFAULT',
    messagingSenderId: dotenv.env['MESSAGING_SENDER_ID'] ?? 'DEFAULT',
    projectId: dotenv.env['PROJECT_ID'] ?? 'DEFAULT',
    authDomain: dotenv.env['AUTH_DOMAIN'] ?? 'DEFAULT',
    storageBucket: dotenv.env['STORAGE_BUCKET'] ?? 'DEFAULT',
  );
}
