import 'package:flutter/material.dart';

final mainTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(239, 239, 239, 239),
  ),
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.white,

  // Стиль AppBar
  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 239, 239, 239),
    foregroundColor: Color.fromARGB(255, 0, 0, 0),
    elevation: 0,
    iconTheme: IconThemeData(color: Color.fromARGB(255, 0, 0, 0)),
  ),

  // Стиль кнопок в нижнем меню
  bottomAppBarTheme: const BottomAppBarTheme(
    color: Colors.white,
    elevation: 2,
  ),

  // Цвет выделения при выборе элементов
  highlightColor: Colors.lightBlue,

  // Стиль иконок
  iconTheme: const IconThemeData(
    color: Colors.black54,
    size: 24,
  ),

  // Добавляем стили текста в TextTheme
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black
    ),
    bodyMedium: TextStyle( 
      fontSize: 16,
      color: Colors.black,
    ),
    bodySmall: TextStyle( 
      fontSize: 14,
      color: Colors.black,
    ),
  ),
);