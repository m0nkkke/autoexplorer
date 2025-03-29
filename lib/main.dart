import 'package:autoexplorer/router/router.dart';
import 'package:autoexplorer/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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