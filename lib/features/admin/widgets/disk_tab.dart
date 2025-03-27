import 'package:autoexplorer/features/storage/widgets/folder_list_item.dart';
import 'package:flutter/material.dart';

class DiskTab extends StatefulWidget {
  const DiskTab({Key? key}) : super(key: key);

  @override
  State<DiskTab> createState() => _DiskTabState();
}

void _onTap(BuildContext context) {
  Navigator.pushNamed(context, '/storage');
}

class _DiskTabState extends State<DiskTab> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(left: 16, top: 16),
      children: [
        Align( 
          alignment: Alignment.centerLeft, 
          child: ElevatedButton.icon(
            onPressed: () {

            },
            icon: const Icon(Icons.add_box, color: Colors.lightBlue, size: 32), 
            label: const Text('Добавить новый регионал'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black, 
              elevation: 0,
            ),
          ),
        ),
        FolderListItem(
          title: 'Регионал 1',
          filesCount: 'dateCreation',
          isSelectionMode: false,
          index: 1,
          isSelected: false,
          onTap: () => _onTap(context),
          isLargeIcons: false,
        ),
        FolderListItem(
          title: 'Регионал 2',
          filesCount: 'dateCreation',
          isSelectionMode: false,
          index: 1,
          isSelected: false,
          onTap: () => _onTap(context),
          isLargeIcons: false,
        ),
        FolderListItem(
          title: 'Регионал 3',
          filesCount: 'dateCreation',
          isSelectionMode: false,
          index: 1,
          isSelected: false,
          onTap: () => _onTap(context),
          isLargeIcons: false,
        )
      ],
    );
  }
}