import 'package:autoexplorer/generated/l10n.dart';
import 'package:flutter/material.dart';

class StorageInfo extends StatefulWidget {
  final bool connectionStatus;
  final int imagesCount;
  final double storagePercentage;
  final double currentStorageSize;
  final double totalStorageSize;

  const StorageInfo({
    super.key,
    required this.connectionStatus,
    required this.imagesCount,
    required this.storagePercentage,
    required this.currentStorageSize,
    required this.totalStorageSize,
  });

  @override
  State<StorageInfo> createState() => _StorageInfoState();
}

class _StorageInfoState extends State<StorageInfo> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 36, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 70,
                height: 70,
                child: CircularProgressIndicator(
                  value: widget.storagePercentage / 100, // % заполнения
                  backgroundColor: Colors.grey.shade300,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                  strokeWidth: 6,
                ),
              ),
              Column(
                children: [
                  Text('${widget.storagePercentage.toStringAsFixed(0)}%',
                      style: TextStyle(fontSize: 16)),
                  Text(
                      '${widget.currentStorageSize.toStringAsFixed(0)}/${widget.totalStorageSize.toStringAsFixed(0)} GB',
                      style: TextStyle(fontSize: 10)),
                ],
              )
            ],
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                      widget.connectionStatus
                          ? Icons.check_circle
                          : Icons.cancel,
                      color:
                          widget.connectionStatus ? Colors.green : Colors.red,
                      size: 18),
                  SizedBox(width: 4),
                  Text(
                      widget.connectionStatus
                          ? S.of(context).diskStatusSuccess
                          : S.of(context).diskStatusFailed,
                      style: TextStyle(fontSize: 14)),
                ],
              ),
              Text(S.of(context).imagesCount(widget.imagesCount),
                  style: TextStyle(fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}
