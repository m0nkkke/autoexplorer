import 'package:flutter/material.dart';

enum SortOption { name, date }

class AppBarViewsort extends StatefulWidget {
  const AppBarViewsort({super.key, required this.onIconSizeChanged});

  final Function(bool) onIconSizeChanged;

  @override
  _AppBarViewsortState createState() => _AppBarViewsortState();
}

class _AppBarViewsortState extends State<AppBarViewsort> {
  bool _isLargeIcons = false;
  SortOption _sortBy = SortOption.name;

  void _toggleIconSize(bool isLarge) {
    setState(() {
      _isLargeIcons = isLarge;
      widget.onIconSizeChanged(isLarge);
    });
  }

  void _sortFiles(SortOption sortBy) {
    setState(() {
      _sortBy = sortBy;
    });
    // Логика сортировки по имени или дате
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.list_outlined),
      onSelected: (value) {
        switch (value) {
          case 'small':
            _toggleIconSize(false);
            break;
          case 'large':
            _toggleIconSize(true);
            break;
          case 'name':
            _sortFiles(SortOption.name);
            break;
          case 'date':
            _sortFiles(SortOption.date);
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        _buildSectionHeader('Вид значков'),
        _buildMenuItem('small', 'Мелкий'),
        _buildMenuItem('large', 'Крупный'),
        const PopupMenuDivider(),
        _buildSectionHeader('Сортировка'),
        _buildMenuItem('name', 'Сортировка по имени'),
        _buildMenuItem('date', 'Сортировка по дате создания'),
      ],
    );
  }


// Методы для построения элементов
  PopupMenuItem<String> _buildMenuItem(String value, String text) {
    return PopupMenuItem<String>(
      value: value,
      child: Text(text),
    );
  }

  PopupMenuItem<String> _buildSectionHeader(String text) {
    return PopupMenuItem<String>(
      enabled: false,
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
