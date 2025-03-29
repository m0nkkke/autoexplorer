class Regional {
  final String name;

  Regional({required this.name});

  factory Regional.fromMap(Map<String, dynamic>? map) {
    if (map == null) return Regional(name: '');
    return Regional(name: map['regName'] as String? ?? '');
  }

  Map<String, dynamic> toMap() => {'regName': name};
}