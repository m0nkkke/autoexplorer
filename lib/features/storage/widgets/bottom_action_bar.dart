import 'package:flutter/material.dart';

class BottomActionBar extends StatelessWidget {
  const BottomActionBar({super.key});

  // final VoidCallback onCopy;
  // final VoidCallback onMove;
  // final VoidCallback onRename;
  // final VoidCallback onDelete;

  // const BottomActionBar({
  //   Key? key,
  //   required this.onCopy,
  //   required this.onMove,
  //   required this.onRename,
  //   required this.onDelete,
  // }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.content_copy),
                    onPressed: () {}, // Логика копирования
                  ),
                  IconButton(
                    icon: const Icon(Icons.drive_file_move),
                    onPressed: () {}, // Логика перемещения
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {}, // Логика переименования
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {}, // Удаление элементов
                  ),
                ],
              ),
            );
  }
}
