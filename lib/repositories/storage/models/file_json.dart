class FileJSON {
  final String type; // 'file' or 'folder'
  final String uploadPath; // Local path
  final String remotePath; // Remote path on Yandex.Disk
  bool isSynced;

  FileJSON({
    required this.type,
    required this.uploadPath,
    required this.remotePath,
    this.isSynced = false,
  });

  // Метод для создания объекта из JSON
  factory FileJSON.fromJson(Map<String, dynamic> json) {
    return FileJSON(
      type: json['type'] as String,
      uploadPath: json['uploadPath'] as String,
      remotePath: json['remotePath'] as String,
      isSynced: json['isSynced'] as bool? ?? false,
    );
  }

  // Метод для преобразования объекта в JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'uploadPath': uploadPath,
      'remotePath': remotePath,
      'isSynced': isSynced,
    };
  }
}
