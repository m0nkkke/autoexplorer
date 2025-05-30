import 'package:autoexplorer/repositories/storage/models/abstract_file.dart';

class FileItem extends Abstractfile {
  FileItem({
    required super.name,
    required this.creationDate,
    required super.path,
    required this.imageURL,
  });

  final String creationDate;
  final String imageURL;
}
