import 'dart:io';
import 'dart:async';
import 'package:autoexplorer/connectivityService.dart';
import 'package:autoexplorer/features/storage/bloc/storage_list_bloc.dart';
import 'package:autoexplorer/features/storage/view/image_view_screen.dart';
import 'package:autoexplorer/features/storage/widgets/app_bar.dart';
import 'package:autoexplorer/features/storage/widgets/app_bar_mode.dart';
import 'package:autoexplorer/features/storage/widgets/app_bar_viewsort.dart';
import 'package:autoexplorer/features/storage/widgets/bottom_action_bar.dart';
import 'package:autoexplorer/features/storage/widgets/file_list_item.dart';
import 'package:autoexplorer/features/storage/widgets/image_source_sheet.dart';
import 'package:autoexplorer/generated/l10n.dart';
import 'package:autoexplorer/global.dart';
import 'package:autoexplorer/repositories/notifications/abstract_notifications_repository.dart';
import 'package:autoexplorer/repositories/storage/models/abstract_file.dart';
import 'package:autoexplorer/repositories/storage/models/fileItem.dart';
import 'package:autoexplorer/repositories/storage/models/folder.dart';
import 'package:autoexplorer/repositories/storage/models/sortby.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import '../widgets/folder_list_item.dart';
import 'package:path/path.dart' as p;
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
  SortBy _sortBy = SortBy.name;
  bool _ascending = true;
  final _searchController = TextEditingController();
  //

  final _storageListBloc = StorageListBloc();
  // final _storageListBloc = GetIt.I<StorageListBloc>();

  // ВРЕМЕННЫЕ ПЕРЕМЕННЫЕ ДЛЯ ДЕМОНСТРАЦИИ

  //
// Подписка на стрим доступности интернета
  late StreamSubscription<bool> _internetAvailableSubscription;
  // Состояние для отображения кнопки синхронизации
  bool _showSyncButton = false;

  Future<void> _initNotifications() async {
    final repository = GetIt.I<NotificationsRepositoryI>();
    final result = await repository.requestPermisison();
    if (result) {
      repository.getToken().then((token) => debugPrint('TOKEN PUSH: $token'));
    }
  }

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

  String formatDate(String iso) {
    final dt = DateTime.parse(iso);
    return DateFormat('dd.MM.yyyy HH:mm').format(dt);
  }
  //

  // ЗАГРУЗКА СОДЕРЖИМОГО ДИСКА
  List<dynamic> filesAndFolders = [];

  // ДОБАВИТЬ ФОТО В ПАПКУ
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      File file = File(image.path);
      debugPrint('Выбрано изображение: ${file.path}');

      // Генерируем уникальное имя файла
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'photo_$timestamp.jpg';
      late String uploadPath;
      if (widget.path == '/' || widget.path.isEmpty) {
        uploadPath = fileName;
      } else {
        uploadPath = '${widget.path}/$fileName';
      }

      // '${widget.path.isEmpty ? '' : '${widget.path}/'}$fileName';

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

  // Метод для ручного запуска синхронизации
  void _manualSync() {
    _storageListBloc.add(ManualSyncEvent(currentPath: widget.path));
    // Опционально: скрыть кнопку синхронизации после запуска
    // setState(() {
    //   _showSyncButton = false;
    // });
  }

  void refreshItems() {
    // При ручном обновлении списка просто загружаем его
    _storageListBloc.add(StorageListLoad(path: widget.path));
  }

  @override
  void dispose() {
    // Отписываемся от стрима при уничтожении виджета
    _internetAvailableSubscription.cancel();
    _storageListBloc.close(); // Не забудьте закрыть Bloc
    super.dispose();
  }

  void _deleteSelectedItems() {
    // Получаем выбранные папки (исключаем файлы)
    final foldersToDelete = _selectedItems
        .where((index) =>
            filesAndFolders[index] is FolderItem ||
            filesAndFolders[index] is FileItem)
        .map((index) => filesAndFolders[index] as Abstractfile)
        .toList();

    if (foldersToDelete.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(S.of(context).confrimDelete),
          content: Text(
              S.of(context).areYouSureToDeleteNFolders(foldersToDelete.length)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(S.of(context).cancelButton),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _performDeletion(foldersToDelete);
              },
              child: Text(S.of(context).deleteButton,
                  style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).selectFoldersToDelete)),
      );
    }
  }

  void _performDeletion(List<Abstractfile> folders) {
    for (final folder in folders) {
      _storageListBloc.add(
        DeleteFolderEvent(
          folderName: folder.name,
          currentPath: widget.path,
        ),
      );
    }
    _clearSelection();
  }

  @override
  void initState() {
    // _storageListBloc.add(SyncFromYandexEvent(path: widget.path));
    // _storageListBloc.add(SyncToYandexEvent(path: widget.path));
    debugPrint("INIT STATE storage_view");

    debugPrint("globalRole");
    debugPrint(globalRole.toString());

    // Загружаем список файлов при инициализации
    _storageListBloc.add(StorageListLoad(path: widget.path));

    debugPrint(widget.path);
    _initNotifications();
    // _loadData(path: widget.path);
    // Подписываемся на стрим доступности интернета
    _internetAvailableSubscription = GetIt.I<ConnectivityService>()
        .internetAvailableStream
        .listen((isAvailable) {
      if (isAvailable) {
        // Показываем Snackbar при появлении интернета
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S
                .of(context)
                .internetHasArrived), // Возможно, стоит использовать S.of(context).your_localization_key
            // action: SnackBarAction(
            //   label: 'Синхронизировать', // S.of(context).your_localization_key
            //   onPressed: _manualSync,
            // ),
            duration: Duration(seconds: 2), // Snackbar будет виден 10 секунд
          ),
        );
        // Показываем кнопку синхронизации в AppBar
        setState(() {
          _showSyncButton = true;
        });
      } else {
        // Скрываем кнопку синхронизации при отсутствии интернета
        setState(() {
          _showSyncButton = false;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final fullPath = widget.path;
    String viewPath;
    if (fullPath.contains('applicationData')) {
      viewPath = fullPath.substring(
          fullPath.indexOf('applicationData') + 'applicationData'.length + 1);
    } else {
      viewPath = fullPath;
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: widget.title,
        path: viewPath,
        isSelectionMode: _isSelectionMode,
        selectedCount: _selectedItems.length,
        onCancel: _appBarMode == AppBarMode.selection
            ? _clearSelection
            : _onCancelSearch,
        onSelectAll: _onSelectAll,
        isAllSelected: _selectedItems.length == filesAndFolders.length,
        onSearch: _onSearch,
        searchController: _searchController,
        onSearchChanged: (query) {
          final sq = query.trim().isEmpty ? null : query.trim();
          _storageListBloc.add(StorageListLoad(
            path: widget.path,
            sortBy: _sortBy,
            ascending: _ascending,
            searchQuery: sq,
          ));
        },
        mode: _appBarMode,
        onIconSizeChanged: _updateIconSize,
        onSortChanged: (sortOption, ascending) {
          setState(() {
            _sortBy = sortOption == SortOption.name ? SortBy.name : SortBy.date;
            _ascending = ascending;
          });
          _storageListBloc.add(StorageListLoad(
            path: widget.path,
            sortBy: _sortBy,
            ascending: _ascending,
            // сохраняем текущий поисковый текст
            searchQuery: _searchController.text.trim().isEmpty
                ? null
                : _searchController.text.trim(),
          ));
        },
        onCreateFolder: (folderName) {
          _storageListBloc.add(
            StorageListCreateFolder(name: folderName, path: widget.path),
          );
        },
        // onDelete: _isSelectionMode ? _deleteSelectedItems : null,
        refreshItems: refreshItems,
        onSyncedFiles: _manualSync,
        onDeleteSynced: () {
          // здесь собираем все синхронизированные FileItem и диспатчим удаление
          final synced = filesAndFolders
              .whereType<FileItem>()
              .where((f) => f.isSynced)
              .toList();
          for (final f in synced) {
            final name = p.basename(f.path);
            final parent = p.dirname(f.path);
            _storageListBloc.add(DeleteFolderEvent(
              folderName: name,
              currentPath: parent,
            ));
          }
        },
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          refreshItems();
        },
        child: BlocBuilder<StorageListBloc, StorageListState>(
          bloc: _storageListBloc,
          builder: (context, state) {
            final theme = Theme.of(context);
            if (state is StorageListLoaded && state.items.isNotEmpty) {
              final items = state.items;
              filesAndFolders = state.items;
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  if (item is FileItem) {
                    debugPrint('File item found: ${item.name}');
                    final displayDate = formatDate(item.creationDate);
                    return FileListItem(
                      isSynced: item.isSynced,
                      title: item.name,
                      creationDate: displayDate,
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
                  return null;
                },
              );
            } else if (state is StorageListLoaded) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(S.of(context).noFilesHere),
                  ],
                ),
              );
            } else if (state is StorageListLoadingFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(S.of(context).errorLoading,
                        style: theme.textTheme.titleLarge),
                    Text(state.errorMessage.toString(),
                        style: theme.textTheme.titleLarge),
                    TextButton(
                        onPressed: () {
                          _storageListBloc
                              .add(StorageListLoad(path: widget.path));
                        },
                        child: Text(S.of(context).tryAgainLater))
                  ],
                ),
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(S.of(context).loadingData,
                        style: theme.textTheme.titleLarge),
                    SizedBox(
                      height: 30,
                    ),
                    CircularProgressIndicator(),
                  ],
                ),
              );
            }
          },
        ),
      ),
      //     ? _buildFileList()
      //     : const Center(child: CircularProgressIndicator()),
      bottomNavigationBar: _isSelectionMode ? BottomActionBar() : null,
      floatingActionButton: _isSelectionMode
          ? null
          : (widget.path != '/')
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: FloatingActionButton(
                    onPressed: () {
                      _showImageSourceActionSheet();
                    },
                    backgroundColor: Colors.blue,
                    child: const Icon(Icons.camera_alt),
                  ),
                )
              : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
