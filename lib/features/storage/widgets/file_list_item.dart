import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FileListItem extends StatelessWidget {
  final int index;
  final String title;
  final String creationDate;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback? onLongPress;
  final VoidCallback onTap;
  final bool isLargeIcons;

  const FileListItem({
    super.key,
    required this.index,
    required this.title,
    required this.creationDate,
    required this.isSelectionMode,
    required this.isSelected,
    this.onLongPress,
    required this.onTap,
    required this.isLargeIcons,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = isLargeIcons ? 60.0 : 40.0;

    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Container(
        color: isSelected ? Colors.lightBlue : Colors.transparent,
        child: ListTile(
          leading: SvgPicture.asset(
            'assets/svg/file_icon.svg',
            height: iconSize, 
            width: iconSize, 
          ),
          title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
          subtitle: Text(creationDate, style: Theme.of(context).textTheme.bodySmall),
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