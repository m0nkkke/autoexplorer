import 'package:flutter/material.dart';

class ShowCreateDialog extends StatelessWidget {
  const ShowCreateDialog({super.key});

  @override
  Widget build(BuildContext context) {
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
  }

  static Future<void> showCreateFolderDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierColor: const Color.fromARGB(100, 0, 0, 0),
      builder: (BuildContext context) {
        return const ShowCreateDialog();
      },
    );
  }
}
