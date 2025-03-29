class Line {
  final String name;

  Line({required this.name});

  factory Line.fromMap(Map<String, dynamic>? map) {
    if (map == null) return Line(name: '');
    return Line(name: map['lineName'] as String? ?? '');
  }

  Map<String, dynamic> toMap() => {'lineName': name};
}