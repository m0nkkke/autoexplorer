import 'dart:io';

import 'package:autoexplorer/features/storage/bloc/storage_list_bloc.dart';
import 'package:autoexplorer/features/storage/view/image_view_screen.dart';
import 'package:autoexplorer/features/storage/widgets/app_bar.dart';
import 'package:autoexplorer/features/storage/widgets/app_bar_mode.dart';
import 'package:autoexplorer/features/storage/widgets/bottom_action_bar.dart';
import 'package:autoexplorer/features/storage/widgets/file_list_item.dart';
import 'package:autoexplorer/features/storage/widgets/image_source_sheet.dart';
import 'package:autoexplorer/repositories/storage/abstract_storage_repository.dart';
import 'package:autoexplorer/repositories/storage/models/fileItem.dart';
import 'package:autoexplorer/repositories/storage/models/folder.dart';
import 'package:autoexplorer/repositories/storage/storage_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
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

  final _storageListBloc =
      StorageListBloc(GetIt.I<AbstractStorageRepository>());

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
            name: item.name,
            path: item.path,
            imageUrl: item.imageURL,
            imageViewerBloc: _storageListBloc,
            currentItems: filesAndFolders,
          ),
        ));
      }
    }
  }

  void _onSelectAll(bool value) {
    setState(() {
      if (value) {
        _selectedItems =
            Set.from(List.generate(filesAndFolders.length, (index) => index));
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
      final results = await GetIt.I<AbstractStorageRepository>()
          .getFileAndFolderModels(path: path);
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

  // Future<void> _pickImage(ImageSource source) async {
  //   final XFile? image = await _picker.pickImage(source: source);
  //   if (image != null) {
  //     File file = File(image.path);
  //     print('Выбрано изображение: ${file.path}');
  //   }
  // }
  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      File file = File(image.path);
      print('Выбрано изображение: ${file.path}');

      // Генерируем уникальное имя файла
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'photo_$timestamp.jpg';
      final uploadPath =
          '${widget.path.isEmpty ? '' : '${widget.path}/'}$fileName';

      // Загружаем файл
      _storageListBloc.add(
        StorageListUploadFile(
          filePath: file.path,
          uploadPath: uploadPath,
          currentPath: widget.path,
        ),
      );
    }
  }
  //

  @override
  void initState() {
    _storageListBloc.add(StorageListLoad(path: widget.path));
    // _loadData(path: widget.path);
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
        onCreateFolder: (folderName) {
          _storageListBloc.add(
            StorageListCreateFolder(name: folderName, path: widget.path),
          );
        },
      ),
      body: BlocBuilder<StorageListBloc, StorageListState>(
        bloc: _storageListBloc,
        builder: (context, state) {
          final theme = Theme.of(context);
          if (state is StorageListLoaded) {
            final items = state.items;
            filesAndFolders = state.items;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
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
              },
            );
          } else if (state is StorageListLoadingFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Errorrrrrr", style: theme.textTheme.titleLarge),
                  TextButton(
                      onPressed: () {
                        _storageListBloc
                            .add(StorageListLoad(path: widget.path));
                      },
                      child: Text("Try again later"))
                ],
              ),
            );
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Загрузка данных", style: theme.textTheme.titleLarge),
                SizedBox(height: 10),
                CircularProgressIndicator(),
              ],
            ),
          );
        },
      ),
      //     ? _buildFileList()
      //     : const Center(child: CircularProgressIndicator()),
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

  Widget _buildFileList(List<dynamic> filesAndFolders) {
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
        } else {
          return Container();
        }
      },
    );
  }
}
