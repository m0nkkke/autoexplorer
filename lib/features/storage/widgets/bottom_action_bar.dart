import 'package:flutter/material.dart';
import 'package:autoexplorer/global.dart';
import 'package:autoexplorer/repositories/users/models/user/ae_user_role.dart';

class BottomActionBar extends StatelessWidget {
  const BottomActionBar({super.key});

  void _showNotAvailable(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Функция пока не доступна'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Определяем, является ли текущий пользователь "worker"
    final isWorker = globalRole == UserRole.worker;

    // Для "worker" показываем только кнопку "переименовать"
    final buttons = isWorker
        ? <Widget>[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showNotAvailable(context),
            ),
          ]
        // Для остальных (администраторов) — полный набор
        : <Widget>[
            IconButton(
              icon: const Icon(Icons.content_copy),
              onPressed: () => _showNotAvailable(context),
            ),
            IconButton(
              icon: const Icon(Icons.drive_file_move),
              onPressed: () => _showNotAvailable(context),
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showNotAvailable(context),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _showNotAvailable(context),
            ),
          ];

    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: buttons,
      ),
    );
  }
}
