import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight * 1.5); // Увеличенная высота

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          // Обработка нажатия на кнопку "назад"
        },
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Регионал 321',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            'Хранится 1540 папок | заполнено 50%',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.view_list),
          onPressed: () {
            // Обработка нажатия на иконку списка
          },
        ),
        IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () {
            // Обработка нажатия на иконку меню
          },
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(0.0),
        child: Container(
          color: Colors.transparent, // Прозрачный разделитель
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Center(
        child: Text('Содержимое страницы'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Обработка нажатия на кнопку добавления
        },
      ),
    );
  }
}