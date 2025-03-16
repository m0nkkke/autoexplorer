import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FileScreen extends StatelessWidget {
  final String folderName;
  final int imageCount;

  FileScreen({required this.folderName, required this.imageCount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(folderName),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
            child: Text('$imageCount изображений'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Сервер -> $folderName'),
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: imageCount,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: SvgPicture.asset('assets/svg/file_icon.svg', height: 40, width: 40,),
                  title: Text('img3132_gfdas320...'),
                  subtitle: Text('02.02.2025 16:30'),
                  trailing: Checkbox(
                    value: false,
                    onChanged: (bool? value) {
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        },
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}