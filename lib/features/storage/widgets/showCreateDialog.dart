import 'package:autoexplorer/global.dart';
import 'package:autoexplorer/generated/l10n.dart';
import 'package:autoexplorer/repositories/users/models/user/ae_user_role.dart';
import 'package:flutter/material.dart';

class ShowCreateDialog extends StatelessWidget {
  const ShowCreateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    return AlertDialog(
      title: Text(S.of(context).createFolder),
      content: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: S.of(context).folderName,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text(S.of(context).cancelButton),
        ),
        TextButton(
          onPressed: () {
            final folderName = controller.text.trim();
            Navigator.of(context).pop(folderName);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }

  /// Показывает диалог создания папки, но если пользователь-`worker`
  /// в корне (`currentPath == '/'`), вместо диалога выводит SnackBar-подсказку.
  static Future<String?> showCreateFolderDialog(
    BuildContext context, {
    required String currentPath,
  }) {
    // проверяем роль и путь
    final isWorker = globalRole == UserRole.worker;
    if (isWorker && currentPath == '/') {
      // показываем подсказку и не открываем диалог
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
           'Пожалуйста, перейдите в вашу личную папку'
          ),
        ),
      );
      return Future.value(null);
    }

    // иначе — обычный диалог создания
    return showDialog<String?>(
      context: context,
      barrierColor: const Color.fromARGB(100, 0, 0, 0),
      builder: (_) => const ShowCreateDialog(),
    );
  }
}
