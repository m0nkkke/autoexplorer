// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:autoexplorer/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FolderListItem extends StatelessWidget {
  final int index;
  final String title;
  final String filesCount;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback? onLongPress;
  final VoidCallback onTap;
  final bool isLargeIcons;

  const FolderListItem({
    super.key,
    required this.index,
    required this.title,
    required this.filesCount,
    required this.isSelectionMode,
    required this.isSelected,
    this.onLongPress,
    required this.onTap,
    required this.isLargeIcons,
  });

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
          subtitle: Text(S.of(context).filesCount(filesCount),
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
