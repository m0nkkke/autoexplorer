import 'package:autoexplorer/features/admin/widgets/key_list_item.dart';
import 'package:flutter/material.dart';

class ControlTab extends StatelessWidget {
  const ControlTab({Key? key}) : super(key: key);

  @override
 Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(left: 16, top: 16),
      children: [
        Align( 
          alignment: Alignment.centerLeft, 
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pushNamed('/access/create');
            },
            icon: const Icon(Icons.add_box, color: Colors.lightBlue, size: 32), 
            label: const Text('Создать новый ключ доступа'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black, 
              elevation: 0,
            ),
          ),
        ),
        KeyListItem(
          keyUserName: 'Бабиджон', 
          keyArea: 'Регионал 1',
          ),
        KeyListItem(
          keyUserName: 'Бабиджон', 
          keyArea: 'Регионал 1',
          ),
        KeyListItem(
          keyUserName: 'Бабиджон', 
          keyArea: 'Регионал 1',
          ),
        KeyListItem(
          keyUserName: 'Бабиджон', 
          keyArea: 'Регионал 1',
          ),
      ],
    );
  }
}
