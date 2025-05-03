class AccessList {
  final Map<String, String> folders;

  AccessList({required this.folders});

  factory AccessList.fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      return AccessList(folders: {});
    }

    final convertedFolders = data.map<String, String>((key, value) {
      return MapEntry(key, value.toString());
    });

    return AccessList(folders: convertedFolders);
  }

  Map<String, dynamic> toMap() {
    return folders;
  }
}