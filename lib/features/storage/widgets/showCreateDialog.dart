import 'package:flutter/material.dart';

class ShowCreateDialog extends StatelessWidget {
  const ShowCreateDialog({super.key});
  // final String currentPath;

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return AlertDialog(
      title: const Text('Создать папку'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          hintText: "Название папки",
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text('Отмена'),
        ),
        TextButton(
          onPressed: () {
            final folderName = controller.text.trim();
            // Логика создания папки
            Navigator.of(context).pop(folderName);
          },
          child: const Text('Ок'),
        ),
      ],
    );
  }

  static Future<String?> showCreateFolderDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierColor: const Color.fromARGB(100, 0, 0, 0),
      builder: (BuildContext context) {
        return ShowCreateDialog();
      },
    );
  }
}
