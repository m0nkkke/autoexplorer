import 'package:autoexplorer/repositories/users/models/accessList/area.dart';
import 'package:autoexplorer/repositories/users/models/accessList/line.dart';
import 'package:autoexplorer/repositories/users/models/accessList/regional.dart';

class AccessList {
  final Area area;
  final Line line;
  final Regional regional;

  AccessList({required this.area, required this.line, required this.regional});

  factory AccessList.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return AccessList(
        area: Area(name: ''),
        line: Line(name: ''),
        regional: Regional(name: ''),
      );
    }
    return AccessList(
      area: Area.fromMap(map['area'] as Map<String, dynamic>?),
      line: Line.fromMap(map['line'] as Map<String, dynamic>?),
      regional: Regional.fromMap(map['regional'] as Map<String, dynamic>?),
    );
  }

  Map<String, dynamic> toMap() => {
    'area': area.toMap(),
    'line': line.toMap(),
    'regional': regional.toMap(),
  };
}