import 'package:autoexplorer/generated/l10n.dart';
import 'package:autoexplorer/global.dart';
import 'package:autoexplorer/repositories/users/models/user/ae_user_role.dart';
import 'package:flutter/material.dart';
import 'package:autoexplorer/features/storage/widgets/app_bar_menu.dart';
import 'package:autoexplorer/features/storage/widgets/app_bar_mode.dart';
import 'package:autoexplorer/features/storage/widgets/app_bar_viewsort.dart';
import 'package:autoexplorer/features/storage/widgets/showCreateDialog.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final String path;
  final bool isSelectionMode;
  final int selectedCount;
  final VoidCallback onCancel;
  final Function(bool) onIconSizeChanged;
  final void Function(SortOption sortBy, bool ascending) onSortChanged;
  final Function(bool) onSelectAll;
  final VoidCallback onSearch;
  final void Function(String) onSearchChanged;
  final TextEditingController searchController;
  final bool isAllSelected;
  final AppBarMode mode;
  final Function(String) onCreateFolder;
  final VoidCallback refreshItems;
  final VoidCallback? onDelete;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.path,
    required this.isSelectionMode,
    required this.selectedCount,
    required this.onCancel,
    required this.onIconSizeChanged,
    required this.onSelectAll,
    required this.onSearch,
    required this.isAllSelected,
    required this.mode,
    required this.onCreateFolder,
    required this.onDelete,
    required this.refreshItems,
    required this.onSortChanged,
    required this.onSearchChanged,
    required this.searchController,
  });

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  // Назначение размеров аппбара: 20 - при поиске, 56 - при остальных видах
  Size get preferredSize => Size.fromHeight(
      kToolbarHeight + (mode == AppBarMode.search ? 20.0 : 56.0));
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: _buildLeading(),
      title: widget.mode == AppBarMode.search ? _buildSearchField() : null,
      flexibleSpace: _buildFlexibleSpace(context),
      actions: _buildActions(),
      bottom: _buildBottom(),
    );
  }

  // Построение иконки закрытия/выхода
  Widget? _buildLeading() {
    if (widget.mode == AppBarMode.selection) {
      return IconButton(
        icon: const Icon(Icons.close),
        onPressed: widget.onCancel,
      );
    } else if (widget.mode == AppBarMode.search) {
      return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          setState(() {
            widget.onCancel();
          });
        },
      );
    }
    return null;
  }

  // Поисковая строка
  Widget _buildSearchField() {
    return SizedBox(
      width: 200, // подгоните под нужный вам размер
      child: TextField(
        controller: widget.searchController,
        decoration: const InputDecoration(
          hintText: 'Поиск...',
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        onChanged: widget.onSearchChanged, // туда летит каждый новый запрос
      ),
    );
  }

  // Текстовое поле аппбара
  Widget _buildFlexibleSpace(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final topPadding = MediaQuery.of(context).padding.top;
        final desiredPadding = topPadding + 16.0;

        return PreferredSize(
          preferredSize: widget.preferredSize,
          child: Padding(
            padding: EdgeInsets.only(left: 16.0, top: desiredPadding),
            child: widget.mode == AppBarMode.selection
                ? _buildSelectionMode()
                : _buildNormalMode(),
          ),
        );
      },
    );
  }

  // Текстовое поле (при выделении)
  Widget _buildSelectionMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: Text(
            '${widget.selectedCount}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        Text(
          widget.path,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  // Контент текстового поля
  Widget _buildNormalMode() {
    if (widget.mode == AppBarMode.search) {
      return Container();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Text(
              widget.title,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Text(
            widget.path,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      );
    }
  }

  // Кнопки действий
  List<Widget> _buildActions() {
    if (widget.mode == AppBarMode.selection) {
      final isWorker = globalRole == UserRole.worker;
      return [
        if (!isWorker)
          TextButton.icon(
            onPressed: () {
              widget.onSelectAll(!widget.isAllSelected);
            },
            icon: Checkbox(
              value: widget.isAllSelected,
              onChanged: (value) {
                widget.onSelectAll(value ?? false);
              },
            ),
            label: Text(S.of(context).selectAll),
          ),
      ];
    } else if (widget.mode == AppBarMode.search) {
      return [];
    } else {
      return [
        AppBarViewsort(
            onIconSizeChanged: widget.onIconSizeChanged,
            onSortChanged: widget.onSortChanged),
        AppBarMenu(
          onSearch: widget.onSearch,
          path: widget.path,
          onCreateFolder: widget.onCreateFolder,
          onRefresh: () {
            widget.refreshItems;
          },
        ),
      ];
    }
  }

  // Нижняя панель при выделении файлов и папок
  PreferredSizeWidget? _buildBottom() {
    if (widget.mode == AppBarMode.selection ||
        widget.mode == AppBarMode.search) {
      return null;
    } else {
      return PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () async {
                  final folderName =
                      await ShowCreateDialog.showCreateFolderDialog(context,
                          currentPath: widget.path);
                  if (folderName != null) {
                    widget.onCreateFolder(folderName);
                  }
                },
                icon: const Icon(Icons.add_box,
                    color: Colors.lightBlue, size: 36),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
