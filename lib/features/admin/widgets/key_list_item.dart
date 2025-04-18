import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:autoexplorer/features/admin/bloc/control/control_bloc.dart';

class KeyListItem extends StatelessWidget {
  final String keyUserName;
  final String keyArea;
  final Map<String, dynamic> userData;
  final String uid;

  const KeyListItem({
    super.key,
    required this.keyUserName,
    required this.keyArea,
    required this.userData,
    required this.uid,
  });

  void _onTap(BuildContext context) {
    Navigator.of(context).pushNamed(
      '/access', 
      arguments: {
        'userData': userData,
        'uid': uid,
      },
    );
  }

  void _showDeleteDialog(BuildContext context) { 
    showDialog(
      context: context, 
      builder: (BuildContext dialogContext) { 
        return AlertDialog(
          title: const Text("Удалить пользователя?"),
          content: Text("Вы уверены, что хотите удалить пользователя $keyUserName?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text("Отмена"),
            ),
            TextButton(
              onPressed: () {
                context.read<ControlBloc>().add(DeleteUserEvent(uid));
                Navigator.of(dialogContext).pop();
              },
              child: const Text("Удалить"),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(context),
      onLongPress: () => _showDeleteDialog(context),  
      child: ListTile(
        leading: Icon(
          Icons.account_circle, 
          size: 40,
          color: const Color.fromARGB(255, 223, 168, 0),
        ),
        title: Text(keyUserName),
        subtitle: Text(keyArea),
        trailing: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
