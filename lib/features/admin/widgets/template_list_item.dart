import 'package:flutter/material.dart';

class TemplateListItem extends StatelessWidget {

  void _onTap(BuildContext context){
    Navigator.of(context).pushNamed('/template');
  }

  final String templateName;
  const TemplateListItem({
    Key? key,
      required this.templateName
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(context),
      child: ListTile(
        leading: Icon(Icons.dashboard_outlined, size: 40,
        color: const Color.fromARGB(255, 223, 168, 0),),
        title: Text(templateName),
        trailing: Icon(Icons.arrow_forward),
      ),
    );
  }

}