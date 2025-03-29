class Area {
  final String name;
  
  Area({required this.name});

  factory Area.fromMap(Map<String, dynamic>? map) {
    if (map == null) return Area(name: '');
    return Area(name: map['areaName'] as String? ?? '');
  }

  Map<String, dynamic> toMap() => {'areaName': name};
}