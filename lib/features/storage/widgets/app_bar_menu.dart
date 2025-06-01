// File: lib/features/storage/widgets/app_bar_menu.dart

import 'package:autoexplorer/features/storage/widgets/showCreateDialog.dart';
import 'package:autoexplorer/generated/l10n.dart';
import 'package:autoexplorer/global.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum AppBarMenuOption {
  createFolder,
  search,
  refresh,
  syncFiles,
  deleteSynced,
  switchAccount,
}

class AppBarMenu extends StatelessWidget {
  final VoidCallback onSearch;
  final String path;
  final Function(String) onCreateFolder;
  final VoidCallback onRefresh;
  final VoidCallback onSyncFiles;
  final VoidCallback onDeleteSynced;

  const AppBarMenu({
    Key? key,
    required this.onSearch,
    required this.path,
    required this.onCreateFolder,
    required this.onRefresh,
    required this.onDeleteSynced,
    required this.onSyncFiles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = <PopupMenuEntry<AppBarMenuOption>>[
      PopupMenuItem(
        value: AppBarMenuOption.createFolder,
        child: Row(
          children: [
            const Icon(Icons.create_new_folder, color: Colors.black54),
            const SizedBox(width: 8),
            Text(S.of(context).createFolderMenu),
          ],
        ),
      ),
      PopupMenuItem(
        value: AppBarMenuOption.search,
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.black54),
            const SizedBox(width: 8),
            Text(S.of(context).searchMenu),
          ],
        ),
      ),
      PopupMenuItem(
        value: AppBarMenuOption.refresh,
        child: Row(
          children: [
            const Icon(Icons.refresh, color: Colors.black54),
            const SizedBox(width: 8),
            Text(S.of(context).refreshMenu),
          ],
        ),
      ),
      const PopupMenuDivider(),
      PopupMenuItem(
        value: AppBarMenuOption.syncFiles,
        child: Row(
          children: [
            const Icon(Icons.cloud_upload_outlined, color: Colors.black54),
            const SizedBox(width: 8),
            Text(S.of(context).sendToDisk),
          ],
        ),
      ),
      PopupMenuItem(
        value: AppBarMenuOption.deleteSynced,
        child: Row(
          children: [
            const Icon(Icons.delete_sweep, color: Colors.black54),
            const SizedBox(width: 8),
            Text(S.of(context).deleteSyncFiles),
          ],
        ),
      ),
      const PopupMenuDivider(),
      PopupMenuItem(
        value: AppBarMenuOption.switchAccount,
        child: Row(
          children: [
            const Icon(Icons.vpn_key, color: Colors.black54),
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

  Future<void> _onMenuItemSelected(
      AppBarMenuOption option, BuildContext context) async {
    switch (option) {
      case AppBarMenuOption.createFolder:
        final folderName = await ShowCreateDialog.showCreateFolderDialog(
          context,
          currentPath: path,
        );
        if (folderName != null) {
          onCreateFolder(folderName);
        }
        break;

      case AppBarMenuOption.search:
        onSearch();
        break;

      case AppBarMenuOption.refresh:
        onRefresh();
        break;

      case AppBarMenuOption.syncFiles:
        onSyncFiles();
        break;

      case AppBarMenuOption.deleteSynced:
        final confirm = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(S.of(context).deleteSyncWindow),
            content: Text(S.of(context).areYouSureToDeleteSync),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text(S.of(ctx).cancelButton),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text('ОК'),
              ),
            ],
          ),
        );
        if (confirm == true) {
          onDeleteSynced();
        }
        break;

      case AppBarMenuOption.switchAccount:
        await FirebaseAuth.instance.signOut();
        globalAccessList = null;
        globalRole = null;
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/',
          (route) => false,
        );
        break;
    }
  }
}
