// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FolderListItem extends StatelessWidget {
  final int index;
  final String title;
  final String dateCreation;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback onLongPress;
  final VoidCallback onTap;

  const FolderListItem({
    Key? key,
    required this.index,
    required this.title,
    required this.dateCreation,
    required this.isSelectionMode,
    required this.isSelected,
    required this.onLongPress,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      
      onLongPress: onLongPress,
      onTap: onTap,
      child: Container(
        color: isSelected ? Colors.lightBlue : Colors.transparent,
        child: ListTile(
          leading: SvgPicture.asset(
            // ЗДЕСЬ ИКОНКА В ЗАВИСИМОСТИ ОТ ТИПА ФАЙЛА
            'assets/svg/folder_icon.svg',
            height: 40,
            width: 40,
          ),
          // НАЗВАНИЕ ФАЙЛА/ПАПКИ
          title: Text(title, 
            style: Theme.of(context).textTheme.bodyMedium),
          // ДАТА СОЗДАНИЯ
          subtitle: Text(dateCreation, 
             style: Theme.of(context).textTheme.bodySmall),
          trailing: isSelectionMode
              ? Checkbox(
                  value: isSelected,
                  onChanged: (bool? value) {
                    onTap();
                  },
                )
              : const SizedBox(width: 24),
        ),
      ),
    );
    
  }
}
