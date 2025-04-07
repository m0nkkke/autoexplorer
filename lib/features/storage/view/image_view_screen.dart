import 'dart:io';

import 'package:autoexplorer/features/storage/bloc/storage_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class ImageViewerScreen extends StatefulWidget {
  // final FileItem fileItem;
  final String path;
  final String name;
  final String imageUrl;
  final StorageListBloc imageViewerBloc;
  final List<dynamic> currentItems;

  const ImageViewerScreen({
    super.key,
    required this.path,
    required this.name,
    required this.imageUrl,
    required this.imageViewerBloc,
    required this.currentItems,
  });

  @override
  State<ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen> {
  @override
  void initState() {
    widget.imageViewerBloc.add(LoadImageUrl(
        name: widget.name, path: widget.path, imageUrl: widget.imageUrl));
    super.initState();
  }

  @override
  void dispose() {
    // Сбрасываем состояние при закрытии экрана
    widget.imageViewerBloc.add(ResetImageLoadingState(widget.currentItems));
    super.dispose();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: const Text('Просмотр изображения')),
  //     body: BlocBuilder<StorageListBloc, StorageListState>(
  //       builder: (context, state) {
  //         if (state is ImageUrlLoaded) {
  //           return _buildImage(state.imageUrl);
  //         } else if (state is ImageLoadError) {
  //           return const Center(child: Text('Ошибка загрузки изображения'));
  //         }
  //         return const Center(child: CircularProgressIndicator());
  //       },
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Просмотр изображения')),
      body: BlocBuilder<StorageListBloc, StorageListState>(
        bloc: widget.imageViewerBloc,
        builder: (context, state) {
          if (state is ImageUrlLoaded) {
            return _buildImage(state.imageUrl);
          } else if (state is ImageLoadError) {
            return const Center(child: Text('Ошибка загрузки изображения'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    final token = GetIt.I<String>(instanceName: "yandex_token");
    final isNetwork = imageUrl.startsWith('http');
    return Center(
      child: InteractiveViewer(
        child: isNetwork
            ? Image.network(
                headers: {"Authorization": "OAuth ${token}"},
                imageUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  print(error.toString());
                  return const Center(
                      child: Column(
                    children: [
                      Text('Ошибка отображения изображения'),
                    ],
                  ));
                },
              )
            : Image.file(File(imageUrl)),
      ),
    );
  }
}
