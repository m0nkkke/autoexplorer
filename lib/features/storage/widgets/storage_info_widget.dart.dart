import 'package:flutter/material.dart';

class StorageInfoWidget extends StatelessWidget {
  final int folderCount;
  final int storageUsagePercent;

  const StorageInfoWidget({
    super.key,
    required this.folderCount,
    required this.storageUsagePercent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text('Хранится $folderCount папок | заполнено $storageUsagePercent%'),
    );
  }
}
