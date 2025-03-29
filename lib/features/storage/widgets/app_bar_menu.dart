import 'package:autoexplorer/features/storage/widgets/showCreateDialog.dart';
import 'package:flutter/material.dart';

enum AppBarMenuOption { createFolder, search, refresh, switchAccount }

class AppBarMenu extends StatelessWidget {
  final VoidCallback onSearch;
  final path;

  AppBarMenu({super.key, required this.onSearch, required this.path});

  // Заполнение пунктов меню
  final List<_MenuItem> _menuItems = [
    _MenuItem(AppBarMenuOption.createFolder, Icons.add, 'Новая папка'),
    _MenuItem(AppBarMenuOption.search, Icons.search, 'Поиск'),
    _MenuItem(AppBarMenuOption.refresh, Icons.refresh, 'Обновить'),
    _MenuItem(AppBarMenuOption.switchAccount, Icons.vpn_key, 'Сменить'),
  ];

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) => _onMenuItemSelected(value, context),
      itemBuilder: (context) => _menuItems
          .map((item) => PopupMenuItem<int>(
                value: item.option.index,
                child: Row(
                  children: [
                    Icon(item.icon, color: Colors.black54),
                    const SizedBox(width: 8),
                    Text(item.text),
                  ],
                ),
              ))
          .toList(),
    );
  }

  // Обработка выбранного пункта меню
  void _onMenuItemSelected(int value, BuildContext context) {
    final option = AppBarMenuOption.values[value];
    switch (option) {
      case AppBarMenuOption.createFolder:
        ShowCreateDialog.showCreateFolderDialog(context);
        break;
      case AppBarMenuOption.search:
        onSearch();
        break;
      case AppBarMenuOption.refresh:
        Navigator.of(context).pushNamed('/storage');
        break;
      case AppBarMenuOption.switchAccount:
        Navigator.of(context).pushNamed('/admin');
        break;
    }
  }
}

// Вспомогательный класс для представления элементов меню
class _MenuItem {
  final AppBarMenuOption option;
  final IconData icon;
  final String text;

  _MenuItem(this.option, this.icon, this.text);
}
