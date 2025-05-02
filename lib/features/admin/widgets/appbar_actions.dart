import 'package:autoexplorer/generated/l10n.dart';
import 'package:flutter/material.dart';

enum AppBarMenuOption { change }

class AppBarActions extends StatelessWidget {
  AppBarActions({super.key});

  @override
  Widget build(BuildContext context) {
    // Список опций с иконками и локализованными текстами
    final items = <PopupMenuEntry<AppBarMenuOption>>[
      PopupMenuItem(
        value: AppBarMenuOption.change,
        child: Row(
          children: [
            Icon(Icons.key, color: Colors.black54),
            const SizedBox(width: 8),
            Text(S.of(context).switchAccount),
          ],
        ),
      ),
    ];
    return PopupMenuButton<AppBarMenuOption>(
      icon: const Icon(Icons.more_vert),
      onSelected: (option) => _onMenuItemSelected(option, context),
      itemBuilder: (_) => items,
    );
  }

  // Обработка выбранного пункта меню
  void _onMenuItemSelected(AppBarMenuOption option, BuildContext context) {
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
        title: Text(S.of(context).areYouSure),
        content: Text(S.of(context).youWantToChangeAccount),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(S.of(context).cancelButton),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/');
            },
            child: Text(S.of(context).switchAccount),
          ),
        ],
      ),
    );
  }
}
