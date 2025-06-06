import 'package:autoexplorer/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class AccessInfoWidget extends StatefulWidget {
  final bool isNew;
  final String? imagesCreated;
  final String? lastUpload;
  final String? accessGranted;
  final String? accessModified;
  final String? emailKey;

  const AccessInfoWidget(
      {super.key,
      this.isNew = false,
      this.imagesCreated,
      this.lastUpload,
      this.accessGranted,
      this.accessModified,
      this.emailKey});

  @override
  State<AccessInfoWidget> createState() => _AccessInfoWidgetState();
}

class _AccessInfoWidgetState extends State<AccessInfoWidget> {
  String _imagesCreated = '-';
  String _lastUpload = '-';
  String _accessGranted = '-';
  String _accessModified = '-';
  String _emailKey = '';

  @override
  void initState() {
    super.initState();
    if (!widget.isNew) {
      _imagesCreated = widget.imagesCreated ?? '-';
      _lastUpload = widget.lastUpload ?? '-';
      _accessGranted = widget.accessGranted ?? '-';
      _accessModified = widget.accessModified ?? '-';
      _emailKey = widget.emailKey ?? '-';
    }
  }

  String _generateRandomKey() {
    const chars = 'abcdef0123456789';
    final random = Random();
    return List.generate(12, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(S.of(context).imagesCreated, _imagesCreated),
        _buildInfoRow(S.of(context).lastUpload, _lastUpload),
        _buildInfoRow(S.of(context).accessGranted, _accessGranted),
        _buildInfoRow(S.of(context).accessModified, _accessModified),
        _buildCopyableInfoRow(S.of(context).accessKey, _emailKey, context),
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

  Widget _buildCopyableInfoRow(
      String label, String value, BuildContext context) {
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
                        SnackBar(
                          content: Text(S.of(context).keyCopySuccess),
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
                        _emailKey = _generateRandomKey(); // ЧО ЭТО??? ЗАМЕНИТЬ
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
