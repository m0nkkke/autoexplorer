import 'package:flutter/material.dart';

class AppBarMenu extends StatelessWidget {
  const AppBarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        switch (value) {
          case 0:
            _showCreateFolderDialog(context);
            break;
          case 1:
            // Логика поиска
            break;
          case 2:
            // Логика обновления содержимого
            break;
          case 3:
            Navigator.of(context).pushNamed('/'); // Смена аккаунта
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem<int>(
          value: 0,
          child: Row(
            children: [
              Icon(Icons.add, color: Colors.black54),
              SizedBox(width: 8),
              Text('Новая папка'),
            ],
          ),
        ),
        const PopupMenuItem<int>(
          value: 1,
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.black54),
              SizedBox(width: 8),
              Text('Поиск'),
            ],
          ),
        ),
        const PopupMenuItem<int>(
          value: 2,
          child: Row(
            children: [
              Icon(Icons.refresh, color: Colors.black54),
              SizedBox(width: 8),
              Text('Обновить'),
            ],
          ),
        ),
        const PopupMenuItem<int>(
          value: 3,
          child: Row(
            children: [
              Icon(Icons.vpn_key, color: Colors.black54),
              SizedBox(width: 8),
              Text('Сменить'),
            ],
          ),
        ),
      ],
    );
  }

  void _showCreateFolderDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: const Color.fromARGB(100, 0, 0, 0),
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Создать папку'),
          content: const TextField(
            decoration: InputDecoration(
              hintText: "Название папки",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                // Логика создания папки
                Navigator.of(context).pop();
              },
              child: const Text('Ок'),
            ),
          ],
        );
      },
    );
  }
}
