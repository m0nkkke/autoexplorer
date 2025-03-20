import 'package:autoexplorer/features/storage/widgets/app_bar.dart';
import 'package:autoexplorer/features/storage/widgets/bottom_action_bar.dart';
import 'package:flutter/material.dart';
import '../widgets/folder_list_item.dart';

class StorageListScreen extends StatefulWidget {
  const StorageListScreen({super.key, required this.title});

  final String title;

  @override
  State<StorageListScreen> createState() => _StorageListScreenState();
}

class _StorageListScreenState extends State<StorageListScreen> {
  Set<int> _selectedItems = {};
  bool _isSelectionMode = false;

  void _onLongPress(int index) {
    setState(() {
      _isSelectionMode = true;
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
      if (value) {
        _selectedItems = Set.from(List.generate(filesCount, (index) => index));
      } else {
        _selectedItems.clear();
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedItems.clear();
      _isSelectionMode = false;
    });
  }

  // ДИНАМИЧЕСКИЕ ПЕРЕМЕННЫЕ
  final filesCount = 221;
  final path = 'Сервер -> Участок 1 ';
  final storageCount = 'Хранится 1540 папок | заполнено 50%';
  final objectTitle = 'Участок 1';
  final dateCreation = '03.03.2025 16:43:00';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.title,
        storageCount: storageCount,
        path: path,
        isSelectionMode: _isSelectionMode,
        selectedCount: _selectedItems.length,
        onCancel: _clearSelection,
        onSelectAll: _onSelectAll,
        isAllSelected: _selectedItems.length == filesCount,
      ),
      body: ListView.builder(
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
          );
        },
      ),
      bottomNavigationBar: _isSelectionMode ? BottomActionBar() : null,
    );
  }
}