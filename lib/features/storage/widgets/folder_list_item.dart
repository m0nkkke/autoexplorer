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
  final bool isLargeIcons;

  const FolderListItem({
    Key? key,
    required this.index,
    required this.title,
    required this.dateCreation,
    required this.isSelectionMode,
    required this.isSelected,
    required this.onLongPress,
    required this.onTap,
    required this.isLargeIcons, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Размер иконок (вид значков)
    final iconSize = isLargeIcons ? 60.0 : 40.0;

    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Container(
        color: isSelected ? Colors.lightBlue : Colors.transparent,
        child: ListTile(
          leading: SvgPicture.asset(
            'assets/svg/folder_icon.svg',
            height: iconSize, 
            width: iconSize, 
          ),
          title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
          subtitle: Text(dateCreation, style: Theme.of(context).textTheme.bodySmall),
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