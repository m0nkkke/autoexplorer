import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final String storageCount;
  final String path;
  final bool isSelectionMode;
  final int selectedCount;
  final VoidCallback onCancel;
  final Function(bool) onSelectAll;
  final bool isAllSelected;

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.storageCount,
    required this.path,
    required this.isSelectionMode,
    required this.selectedCount,
    required this.onCancel,
    required this.onSelectAll,
    required this.isAllSelected,
  }) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 56.0);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: widget.isSelectionMode
          ? IconButton(
              icon: const Icon(Icons.close),
              onPressed: widget.onCancel,
            )
          : null,
      title: null,
      flexibleSpace: PreferredSize(
        preferredSize: widget.preferredSize,
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, top: 50.0), // НУЖЕН ФИКС
          child: widget.isSelectionMode
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: Text(
                        '${widget.selectedCount}', // количество выбранных объектов
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    Text(
                      widget.storageCount, // кол-во папок и заполненность
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      widget.path, // путь
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: Text(
                        widget.title,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    Text(
                      widget.storageCount,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      widget.path,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
        ),
      ),
      actions: widget.isSelectionMode
          ? [
              TextButton.icon(
                onPressed: () {
                  widget.onSelectAll(!widget.isAllSelected); // передача состояния
                },
                icon: Checkbox(
                  value: widget.isAllSelected,
                  onChanged: (value) {
                    widget.onSelectAll(value ?? false); // передача состояния
                  },
                ),
                label: const Text('Выделить все'),
              ),
            ]
          : [
              IconButton(
                icon: const Icon(Icons.list_outlined, size: 36),
                onPressed: () {
                  Navigator.of(context).pushNamed('/login');
                },
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ],
             bottom: widget.isSelectionMode 
             ? null
             : PreferredSize(
                preferredSize: Size.fromHeight(56.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          // Обработка нажатия на кнопку
                        },
                        icon: const Icon(Icons.add_box, color: Colors.lightBlue, size: 36), 
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}