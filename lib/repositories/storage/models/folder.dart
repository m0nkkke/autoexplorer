import 'package:autoexplorer/repositories/storage/models/abstract_file.dart';
class FolderItem extends Abstractfile {
  FolderItem( 
      {required super.name, required this.filesCount, required super.path, required this.resourceId,});
  // final String name;
  final int filesCount;
  final String resourceId;
  // final String path;
}
