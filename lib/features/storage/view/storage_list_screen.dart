import 'package:autoexplorer/features/storage/widgets/app_bar.dart';
import 'package:autoexplorer/features/storage/widgets/app_bar_mode.dart';
import 'package:autoexplorer/features/storage/widgets/bottom_action_bar.dart';
import 'package:flutter/material.dart';
import '../widgets/folder_list_item.dart';

class StorageListScreen extends StatefulWidget {
  const StorageListScreen({super.key, required this.title});

  final String title;

  @override
  _StorageListScreenState createState() => _StorageListScreenState();
}

class _StorageListScreenState extends State<StorageListScreen> {
  Set<int> _selectedItems = {};
  bool _isSelectionMode = false;
  bool _isLargeIcons = false;
  AppBarMode _appBarMode = AppBarMode.normal;

  int filesCount = 0;
  static const String path = 'Сервер -> Участок 1 ';
  static const String storageCount = 'Хранится 1540 папок | заполнено 50%';
  static const String objectTitle = 'Участок 1';
  static const String dateCreation = '03.03.2025 16:43:00';

  void _updateIconSize(bool isLarge) {
    setState(() {
      _isLargeIcons = isLarge;
    });
  }

  void _onLongPress(int index) {
    setState(() {
      _isSelectionMode = true;
      _appBarMode = AppBarMode.selection;
      _selectedItems.add(index);
    });
  }

  void _onTap(int index) {
    if (_isSelectionMode) {
      setState(() {
        if (_selectedItems.contains(index)) {
          _selectedItems.remove(index);
          if (_selectedItems.isEmpty) {
            _isSelectionMode = false;
            _appBarMode = AppBarMode.normal;
          }
        } else {
          _selectedItems.add(index);
        }
      });
    } else {
      Navigator.of(context).pushNamed('/file');
    }
  }

  void _onSelectAll(bool value) {
    setState(() {
      _selectedItems = value ? Set.from(List.generate(filesCount, (index) => index)) : {};
      _isSelectionMode = _selectedItems.isNotEmpty;
      _appBarMode = _isSelectionMode ? AppBarMode.selection : AppBarMode.normal;
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedItems.clear();
      _isSelectionMode = false;
      _appBarMode = AppBarMode.normal;
    });
  }

  void _onSearch() {
    setState(() {
      _appBarMode = AppBarMode.search;
    });
  }

  void _onCancelSearch() {
    setState(() {
      _appBarMode = AppBarMode.normal;
    });
  }

  @override
  void initState() {
   super.initState();

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        filesCount = 221;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.title,
        storageCount: storageCount,
        path: path,
        isSelectionMode: _isSelectionMode,
        selectedCount: _selectedItems.length,
        onCancel: _appBarMode == AppBarMode.selection
            ? _clearSelection
            : _onCancelSearch,
        onSelectAll: _onSelectAll,
        isAllSelected: _selectedItems.length == filesCount,
        onSearch: _onSearch,
        mode: _appBarMode,
        onIconSizeChanged: _updateIconSize,
      ),
      body: (filesCount == 221 ) 
      ? _buildFileList()
      : const Center(child: CircularProgressIndicator()),
      bottomNavigationBar: _isSelectionMode ? BottomActionBar() : null,
    );
  }

  Widget _buildFileList() {
    return ListView.builder(
      itemCount: filesCount,
      itemBuilder: (context, index) {
        return FolderListItem(
          title: objectTitle,
          dateCreation: dateCreation,
          isSelectionMode: _isSelectionMode,
          index: index,
          isSelected: _selectedItems.contains(index),
          onLongPress: () => _onLongPress(index),
          onTap: () => _onTap(index),
          isLargeIcons: _isLargeIcons,
        );
      },
    );
  }
}
