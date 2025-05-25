import 'package:autoexplorer/features/storage/widgets/showCreateDialog.dart';
import 'package:autoexplorer/generated/l10n.dart';
import 'package:autoexplorer/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum AppBarMenuOption { createFolder, search, refresh, switchAccount }

class AppBarMenu extends StatelessWidget {
  final VoidCallback onSearch;
  final path;

  AppBarMenu({super.key, required this.onSearch, required this.path});

  @override
  Widget build(BuildContext context) {
    // Список опций с иконками и локализованными текстами
    final items = <PopupMenuEntry<AppBarMenuOption>>[
      PopupMenuItem(
        value: AppBarMenuOption.createFolder,
        child: Row(
          children: [
            Icon(Icons.create_new_folder, color: Colors.black54),
            const SizedBox(width: 8),
            Text(S.of(context).createFolderMenu),
          ],
        ),
      ),
      PopupMenuItem(
        value: AppBarMenuOption.search,
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.black54),
            const SizedBox(width: 8),
            Text(S.of(context).searchMenu),
          ],
        ),
      ),
      PopupMenuItem(
        value: AppBarMenuOption.refresh,
        child: Row(
          children: [
            Icon(Icons.refresh, color: Colors.black54),
            const SizedBox(width: 8),
            Text(S.of(context).refreshMenu),
          ],
        ),
      ),
      PopupMenuItem(
        value: AppBarMenuOption.switchAccount,
        child: Row(
          children: [
            Icon(Icons.vpn_key, color: Colors.black54),
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
      case AppBarMenuOption.createFolder:
        ShowCreateDialog.showCreateFolderDialog(context);
        break;
      case AppBarMenuOption.search:
        onSearch();
        break;
      case AppBarMenuOption.refresh:
        Navigator.of(context).pushReplacementNamed('/storage');
        break;
      case AppBarMenuOption.switchAccount:
        FirebaseAuth.instance.signOut(); // ЗАМЕНИТЬ
        globalAccessList = null;
        globalRole = null;
        Navigator.of(context).pushReplacementNamed('/');
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
