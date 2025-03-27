import 'dart:io';

import 'package:autoexplorer/features/storage/view/image_view_screen.dart';
import 'package:autoexplorer/features/storage/widgets/app_bar.dart';
import 'package:autoexplorer/features/storage/widgets/app_bar_mode.dart';
import 'package:autoexplorer/features/storage/widgets/bottom_action_bar.dart';
import 'package:autoexplorer/features/storage/widgets/file_list_item.dart';
import 'package:autoexplorer/features/storage/widgets/image_source_sheet.dart';
import 'package:autoexplorer/repositories/storage/models/fileItem.dart';
import 'package:autoexplorer/repositories/storage/models/folder.dart';
import 'package:autoexplorer/repositories/storage/storage_repository.dart';
import 'package:flutter/material.dart';
import '../widgets/folder_list_item.dart';
import 'package:image_picker/image_picker.dart';

class StorageListScreen extends StatefulWidget {
  const StorageListScreen({super.key, required this.title, this.path = '/'});

  final String title;
  final String path;

  @override
  _StorageListScreenState createState() => _StorageListScreenState();
}

class _StorageListScreenState extends State<StorageListScreen> {
  // СМЕНА ОТОБРАЖЕНИЯ ВИДЖЕТОВ
  Set<int> _selectedItems = {};
  bool _isSelectionMode = false;
  bool _isLargeIcons = false;
  AppBarMode _appBarMode = AppBarMode.normal;
  //

  // ВРЕМЕННЫЕ ПЕРЕМЕННЫЕ ДЛЯ ДЕМОНСТРАЦИИ
  static const String storageCount = 'Хранится 1540 папок | заполнено 50%';
  static const String objectTitle = 'Участок 1';
  static const String dateCreation = '03.03.2025 16:43:00';
  //

  // МЕТОДЫ ДЕЙСТВИЙ НА ЭКРАНЕ
  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ImageSourceSheet(
          onCameraTap: () => _pickImage(ImageSource.camera),
          onGalleryTap: () => _pickImage(ImageSource.gallery),
        );
      },
    );
  }

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
  final item = filesAndFolders[index];
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
    if (item is FolderItem) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => StorageListScreen(
          title: item.name,
          path: item.path,
        ),
      ));
    } else if (item is FileItem) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ImageViewerScreen(
          imageUrl: item.path,
        ),
      ));
    }
  }
}

  void _onSelectAll(bool value) {
    setState(() {
       if (value) {
         _selectedItems = Set.from(List.generate(filesAndFolders.length, (index) => index));
       } else {
         _selectedItems.clear();
       }
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
  //

  // ЗАГРУЗКА СОДЕРЖИМОГО ДИСКА
  List<dynamic> filesAndFolders = [];
  Future<void> _loadData({String path = '/'}) async {
    try {
      final results = await StorageRepository().getFileAndFolderModels(path: path);
      setState(() {
        filesAndFolders = results;
      });
    } catch (e) {
      print('Error: $e');
    }
  }
  //

  // ДОБАВИТЬ ФОТО В ПАПКУ 
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      File file = File(image.path);
      print('Выбрано изображение: ${file.path}');
    }
  }
  //

  @override
  void initState() {
    _loadData(path: widget.path);
    super.initState();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: CustomAppBar(
      title: widget.title,
      storageCount: storageCount,
      path: widget.path,
      isSelectionMode: _isSelectionMode,
      selectedCount: _selectedItems.length,
      onCancel: _appBarMode == AppBarMode.selection
          ? _clearSelection
          : _onCancelSearch,
      onSelectAll: _onSelectAll,
      isAllSelected: _selectedItems.length == filesAndFolders.length,
      onSearch: _onSearch,
      mode: _appBarMode,
      onIconSizeChanged: _updateIconSize,
    ),
    body: filesAndFolders.isNotEmpty
        ? _buildFileList()
        : const Center(child: CircularProgressIndicator()),
    bottomNavigationBar: _isSelectionMode ? BottomActionBar() : null,
    floatingActionButton: _isSelectionMode
        ? null
        : Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: FloatingActionButton(
              onPressed: () {
                _showImageSourceActionSheet();
              },
              backgroundColor: Colors.blue,
              child: const Icon(Icons.camera_alt),
            ),
          ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
  );
}

Widget _buildFileList() {
  return ListView.builder(
    itemCount: filesAndFolders.length,
    itemBuilder: (context, index) {
      final item = filesAndFolders[index];
      if (item is FileItem) {
         print('File item found: ${item.name}');
        return FileListItem(
          title: item.name,
          creationDate: item.creationDate,
          isSelectionMode: _isSelectionMode,
          index: index,
          isSelected: _selectedItems.contains(index),
          onLongPress: () => _onLongPress(index),
          onTap: () => _onTap(index),
          isLargeIcons: _isLargeIcons,
        );
      } else if (item is FolderItem) {
        return FolderListItem(
          title: item.name,
          filesCount: item.filesCount.toString(),
          isSelectionMode: _isSelectionMode,
          index: index,
          isSelected: _selectedItems.contains(index),
          onLongPress: () => _onLongPress(index),
          onTap: () => _onTap(index),
          isLargeIcons: _isLargeIcons,
        );
      }
      return Container();
    },
  );
}
}
