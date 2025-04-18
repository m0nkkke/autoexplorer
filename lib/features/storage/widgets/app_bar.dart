import 'package:autoexplorer/features/storage/widgets/app_bar_menu.dart';
import 'package:autoexplorer/features/storage/widgets/app_bar_mode.dart';
import 'package:autoexplorer/features/storage/widgets/app_bar_viewsort.dart';
import 'package:autoexplorer/features/storage/widgets/showCreateDialog.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final String storageCount;
  final String path;
  final bool isSelectionMode;
  final int selectedCount;
  final VoidCallback onCancel;
  final Function(bool) onIconSizeChanged;
  final Function(bool) onSelectAll;
  final VoidCallback onSearch;
  final bool isAllSelected;
  final AppBarMode mode;
  final Function(String) onCreateFolder;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.storageCount,
    required this.path,
    required this.isSelectionMode,
    required this.selectedCount,
    required this.onCancel,
    required this.onSelectAll,
    required this.isAllSelected,
    required this.onSearch,
    required this.mode,
    required this.onIconSizeChanged,
    required this.onCreateFolder,
  });

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  // Назначение размеров аппбара: 20 - при поиске, 56 - при остальных видах
  Size get preferredSize => Size.fromHeight(
      kToolbarHeight + (mode == AppBarMode.search ? 20.0 : 56.0));
}

class _CustomAppBarState extends State<CustomAppBar> {
  final TextEditingController _searchController = TextEditingController();

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
    return TextField(
      controller: _searchController,
      decoration: const InputDecoration(
        hintText: 'Поиск...',
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
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
          widget.storageCount,
          style: Theme.of(context).textTheme.bodyMedium,
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
            widget.storageCount,
            style: Theme.of(context).textTheme.bodyMedium,
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
      return [
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
          label: const Text('Выделить все'),
        ),
      ];
    } else if (widget.mode == AppBarMode.search) {
      return [];
    } else {
      return [
        AppBarViewsort(onIconSizeChanged: widget.onIconSizeChanged),
        AppBarMenu(onSearch: widget.onSearch, path: widget.path),
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
                      await ShowCreateDialog.showCreateFolderDialog(context);
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
