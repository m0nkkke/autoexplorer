import 'package:flutter/material.dart';

class AppBarViewsort extends StatefulWidget {
  const AppBarViewsort({super.key});

  @override
  _AppBarViewsortState createState() => _AppBarViewsortState();
}

class _AppBarViewsortState extends State<AppBarViewsort> {
  bool _isLargeIcons = false; // Переключатель между крупными и мелкими значками
  String _sortBy = 'name'; // Сортировка по имени или дате

  void _toggleIconSize(bool isLarge) {
    setState(() {
      _isLargeIcons = isLarge;
    });
  }

  void _sortFiles(String sortBy) {
    setState(() {
      _sortBy = sortBy;
    });
    // Логика сортировки по имени или дате
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.list_outlined),
      onSelected: (value) {
        switch (value) {
          case 'small':
            _toggleIconSize(false); // Мелкий размер значков
            break;
          case 'large':
            _toggleIconSize(true); // Крупный размер значков
            break;
          case 'name':
            _sortFiles('name'); // Сортировка по имени
            break;
          case 'date':
            _sortFiles('date'); // Сортировка по дате создания
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          enabled: false,
          child: Text(
            'Вид значков',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'small',
          child: Text('Мелкий'),
        ),
        const PopupMenuItem<String>(
          value: 'large',
          child: Text('Крупный'),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<String>(
          enabled: false,
          child: Text(
            'Сортировка',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'name',
          child: Text('Сортировка по имени'),
        ),
        const PopupMenuItem<String>(
          value: 'date',
          child: Text('Сортировка по дате создания'),
        ),
      ],
    );
  }
}
