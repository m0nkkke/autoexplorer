import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class AccessInfoWidget extends StatefulWidget {
  final bool isNew;
  final String? imagesCreated;
  final String? lastUpload;
  final String? accessGranted; 
  final String? accessModified; 
  final String? accessKey;

  const AccessInfoWidget({super.key, this.isNew = false, this.imagesCreated, this.lastUpload, this.accessGranted, this.accessModified, this.accessKey});

  @override
  State<AccessInfoWidget> createState() => _AccessInfoWidgetState();
}

class _AccessInfoWidgetState extends State<AccessInfoWidget> {
  String _imagesCreated = '-';
  String _lastUpload = '-';
  String _accessGranted = '-';
  String _accessModified = '-';
  String _accessKey = '';

  @override
  void initState() {
    super.initState();
    if (!widget.isNew) {
      _imagesCreated = widget.imagesCreated ?? '-';
      _lastUpload = widget.lastUpload ?? '-';
      _accessGranted = widget.accessGranted ?? '-';
      _accessModified = widget.accessModified ?? '-';
      _accessKey = widget.accessKey ?? '-';
    }
  }

  String _generateRandomKey() {
    const chars = 'abcdef0123456789';
    final random = Random();
    return List.generate(12, (index) => chars[random.nextInt(chars.length)]).join();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Изображений создано', _imagesCreated),
        _buildInfoRow('Последняя загрузка', _lastUpload),
        _buildInfoRow('Доступ выдан', _accessGranted),
        _buildInfoRow('Доступ изменен', _accessModified),
        _buildCopyableInfoRow('Ключ доступа', _accessKey, context),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 200,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                value.isNotEmpty ? value : '-',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCopyableInfoRow(String label, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 200,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: value.isNotEmpty
                ? GestureDetector(
                    onTap: () async {
                      await Clipboard.setData(ClipboardData(text: value));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Ключ доступа скопирован в буфер обмена'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Text(
                      value,
                      style: const TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                : ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _accessKey = _generateRandomKey();
                      });
                    },
                    child: const Text('Генерация'),
                  ),
          ),
        ],
      ),
    );
  }
}
