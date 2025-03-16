import 'package:autoexplorer/router/router.dart';
import 'package:autoexplorer/theme/theme.dart';
import 'package:flutter/material.dart';

void main() {
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