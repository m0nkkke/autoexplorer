import 'package:flutter/material.dart';

enum AppBarMenuOption { change }

class AppBarActions extends StatelessWidget {
  AppBarActions({Key? key}) : super(key: key);

  // Заполнение пункта меню
  final List<_MenuItem> _menuItems = [
    _MenuItem(AppBarMenuOption.change, Icons.key, 'Сменить'),
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
      case AppBarMenuOption.change:
        _showChangeDialog(context);
        break;
    }
  }

  // Пример отображения диалога
  void _showChangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выйти из панели?'),
        content: const Text('Вы хотите сменить аккаунт?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/');
            },
            child: const Text('Сменить'),
          ),
        ],
      ),
    );
  }
}

// Вспомогательный класс для представления элементов меню
class _MenuItem {
  final AppBarMenuOption option;
  final IconData icon;
  final String text;

  _MenuItem(this.option, this.icon, this.text);
}