class FileJSON {
  final String type; // "folder" или "file"
  final String uploadPath; // путь на устройстве
  final String remotePath; // путь, который будет на Яндекс.Диске

  FileJSON({
    required this.type,
    required this.uploadPath,
    required this.remotePath,
  });
  factory FileJSON.fromJson(Map<String, dynamic> json) => FileJSON(
        type: json['type'] as String,
        uploadPath: json['uploadPath'] as String,
        remotePath: json['remotePath'] as String,
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'uploadPath': uploadPath,
        'remotePath': remotePath,
      };
}
