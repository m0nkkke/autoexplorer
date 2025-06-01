import 'package:autoexplorer/generated/l10n.dart';
import 'package:flutter/material.dart';

class ImageSourceSheet extends StatelessWidget {
  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;

  const ImageSourceSheet({
    super.key,
    required this.onCameraTap,
    required this.onGalleryTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.camera_alt, color: Colors.blue),
                const SizedBox(width: 8),
                Text(S.of(context).cameraMode),
              ],
            ),
            onTap: () {
              Navigator.of(context).pop();
              onCameraTap();
            },
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.photo, color: Colors.blue),
                const SizedBox(width: 8),
                Text(S.of(context).galleryMode),
              ],
            ),
            onTap: () {
              Navigator.of(context).pop();
              onGalleryTap();
            },
          ),
        ],
      ),
    );
  }
}
