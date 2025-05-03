import 'package:autoexplorer/generated/l10n.dart';
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
        _buildSectionHeader(S.of(context).iconsViewMode),
        _buildMenuItem('small', S.of(context).iconsViewModeSmall),
        _buildMenuItem('large', S.of(context).iconsViewModeLarge),
        const PopupMenuDivider(),
        _buildSectionHeader(S.of(context).sortModeTitle),
        _buildMenuItem('name', S.of(context).sortByName),
        _buildMenuItem('date', S.of(context).sortByDate),
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
