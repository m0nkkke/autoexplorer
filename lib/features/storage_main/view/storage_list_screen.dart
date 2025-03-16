import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StorageListScreen extends StatefulWidget {
  const StorageListScreen({super.key, required this.title});

  final String title;

  @override 
  State<StorageListScreen> createState() => _StorageListScreenState();
}

class _StorageListScreenState extends State<StorageListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: Text('Серверное хранилище'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Хранится 30 папок | заполнено 30%'),
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: 221, 
              itemBuilder: (context, index) {
                return ListTile(
                  leading: SvgPicture.asset('assets/svg/folder_icon.svg', height: 40, width: 40,),
                  title: Text('Участок ${index + 1}'),
                  subtitle: Text('30 изображений'),
                  trailing: Checkbox(
                    value: true, 
                    onChanged: (bool? value) {
                    },
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed('/file');
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        },
        child: Icon(Icons.add),
      ),
    );
  }
}