import 'package:flutter/material.dart';

class KeyListItem extends StatelessWidget {
  final String keyUserName;
  final String keyArea;
  final Map<String, dynamic> userData;
  final String uid;

  const KeyListItem({
    Key? key,
    required this.keyUserName,
    required this.keyArea,
    required this.userData,
    required this. uid,
  }) : super(key: key);

  void _onTap(BuildContext context) {
    Navigator.of(context).pushNamed(
      '/access', 
      arguments: {
        'userData': userData,
        'uid': uid,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(context),
      child: ListTile(
        leading: Icon(
          Icons.account_circle, 
          size: 40,
          color: const Color.fromARGB(255, 223, 168, 0),
        ),
        title: Text(keyUserName),
        subtitle: Text(keyArea),
        trailing: Icon(Icons.arrow_forward),
      ),
    );
  }
}
