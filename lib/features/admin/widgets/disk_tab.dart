import 'package:autoexplorer/features/admin/bloc/control/disk_bloc.dart';
import 'package:autoexplorer/features/storage/view/storage_list_screen.dart';
import 'package:autoexplorer/features/storage/widgets/folder_list_item.dart';
import 'package:autoexplorer/features/storage/widgets/showCreateDialog.dart';
import 'package:autoexplorer/repositories/storage/abstract_storage_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class DiskTab extends StatefulWidget {
  const DiskTab({super.key});

  @override
  State<DiskTab> createState() => _DiskTabState();
}

void _onTap(BuildContext context, item) {
  // Navigator.of(context).pushNamed('/storage');
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => StorageListScreen(
      title: item.name,
      path: item.path,
    ),
  ));
}

class _DiskTabState extends State<DiskTab> {
  final _disk_bloc = DiskBloc(
      storageRepository: GetIt.I<AbstractStorageRepository>(
          instanceName: 'yandex_repository'));

  @override
  void initState() {
    _disk_bloc.add(DiskLoadFoldersEvent());
    // _loadData(path: widget.path);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<DiskBloc, DiskState>(
      bloc: _disk_bloc,
      builder: (context, state) {
        if (state is DiskLoaded) {
          return ListView(
            padding: const EdgeInsets.only(left: 16, top: 16),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final folderName =
                        await ShowCreateDialog.showCreateFolderDialog(context);
                    if (folderName != null) {
                      // Вызов логики создания папки
                      _disk_bloc
                          .add(DiskCreateFolderEvent(folderName: folderName));
                      // context
                      //     .read<DiskBloc>()
                      //     .add(CreateFolderOnDisk(folderName));
                    }
                  },
                  icon: const Icon(Icons.add_box,
                      color: Colors.lightBlue, size: 32),
                  label: const Text('Добавить новый регионал'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.black,
                    elevation: 0,
                  ),
                ),
              ),
              ...List.generate(state.items.length, (index) {
                final regional = state.items[index];
                return FolderListItem(
                  title: regional.name,
                  filesCount: regional.filesCount.toString(),
                  isSelectionMode: false,
                  index: index, // Используем индекс в списке
                  isSelected: false,
                  onTap: () => _onTap(context, regional),
                  isLargeIcons: false,
                );
              }),
            ],
          );
        }
        if (state is DiskError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Disk Error"),
              ],
            ),
          );
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Загрузка данных", style: theme.textTheme.titleLarge),
              SizedBox(
                height: 30,
              ),
              const CircularProgressIndicator(),
            ],
          ),
        ); // или другой виджет для состояний загрузки/ошибки
      },
    );
  }
}
