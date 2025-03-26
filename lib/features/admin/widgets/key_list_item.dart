import 'package:flutter/material.dart';


class KeyListItem extends StatelessWidget {

  void _onTap(BuildContext context){
    Navigator.of(context).pushNamed('/access');
  }

  final String keyUserName;
  final String keyArea;
  const KeyListItem({
    Key? key,
    required this.keyUserName,
    required this.keyArea,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(context),
      child: ListTile(
        leading: Icon(Icons.account_circle, size: 40,
        color: const Color.fromARGB(255, 223, 168, 0),),
        title: Text(keyUserName),
        subtitle: Text(keyArea),
        trailing: Icon(Icons.arrow_forward),
      ),
    );
  }

}