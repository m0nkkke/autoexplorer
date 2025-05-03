import 'package:autoexplorer/generated/l10n.dart';
import 'package:flutter/material.dart';

class ShowCreateDialog extends StatelessWidget {
  const ShowCreateDialog({super.key});
  // final String currentPath;

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
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
            // Логика создания папки
            Navigator.of(context).pop(folderName);
          },
          child: Text('ОК'),
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
