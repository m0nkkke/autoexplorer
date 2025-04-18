import 'package:flutter/material.dart';

class StorageInfo extends StatefulWidget {

  final bool connectionStatus;
  final int imagesCount;
  final int foldersCount;
  final double storagePercentage;
  final double currentStorageSize;
  final double totalStorageSize;

  const StorageInfo({
    super.key, 
    required this.connectionStatus, 
    required this.imagesCount, 
    required this.foldersCount, 
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
              Column(children: [
                Text('${widget.storagePercentage.toStringAsFixed(0)}%', style: TextStyle(fontSize: 16)),
                Text('${widget.currentStorageSize.toStringAsFixed(0)}/${widget.totalStorageSize.toStringAsFixed(0)} ГБ', style: TextStyle(fontSize: 10)),
              ],)
            ],
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(widget.connectionStatus ? Icons.check_circle : Icons.cancel, 
                  color: widget.connectionStatus ? Colors.green : Colors.red, 
                  size: 18),
                  SizedBox(width: 4),
                  Text(widget.connectionStatus ? 'Диск подключен' : 'Диск не подключен',
                  style: TextStyle(fontSize: 14)),
                ],
              ),
              Text('Изображений: ${widget.imagesCount} шт.', style: TextStyle(fontSize: 14)),
              Text('Папок: ${widget.foldersCount} шт.', style: TextStyle(fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}
