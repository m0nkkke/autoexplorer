// File: app_bar_viewsort.dart

import 'package:autoexplorer/generated/l10n.dart';
import 'package:flutter/material.dart';

enum SortOption { name, date }

class AppBarViewsort extends StatefulWidget {
  final Function(bool) onIconSizeChanged;
  final Function(SortOption, bool) onSortChanged;

  const AppBarViewsort({
    super.key,
    required this.onIconSizeChanged,
    required this.onSortChanged,
  });

  @override
  _AppBarViewsortState createState() => _AppBarViewsortState();
}

class _AppBarViewsortState extends State<AppBarViewsort> {
  bool _isLargeIcons = false;
  SortOption _sortBy = SortOption.name;
  bool _ascending = true;

  void _toggleIconSize(bool isLarge) {
    setState(() => _isLargeIcons = isLarge);
    widget.onIconSizeChanged(isLarge);
  }

  void _sortFiles(SortOption sortBy) {
    setState(() {
      if (_sortBy == sortBy) {
        // переключаем направление
        _ascending = !_ascending;
      } else {
        _sortBy = sortBy;
        _ascending = true;
      }
    });
    widget.onSortChanged(_sortBy, _ascending);
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
        PopupMenuItem<String>(
          enabled: false,
          child: Text(S.of(context).iconsViewMode,
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        PopupMenuItem(
            value: 'small', child: Text(S.of(context).iconsViewModeSmall)),
        PopupMenuItem(
            value: 'large', child: Text(S.of(context).iconsViewModeLarge)),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          enabled: false,
          child: Text(S.of(context).sortModeTitle,
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        PopupMenuItem(
          value: 'name',
          child: Row(
            children: [
              Text(S.of(context).sortByName),
              if (_sortBy == SortOption.name)
                Icon(_ascending ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 16),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'date',
          child: Row(
            children: [
              Text(S.of(context).sortByDate),
              if (_sortBy == SortOption.date)
                Icon(_ascending ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 16),
            ],
          ),
        ),
      ],
    );
  }
}
