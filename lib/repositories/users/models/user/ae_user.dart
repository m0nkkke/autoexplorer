import 'package:autoexplorer/repositories/users/models/user/ae_user_role.dart';

class AEUser {
  String uid;
  final String email;
  String accessEdit;
  String regional;
  List<String> accessList; 
  String accessSet;
  String firstName;
  int imagesCount;
  String lastName;
  String lastUpload;
  String middleName;
  final UserRole role;

  AEUser({
    required this.uid,
    required this.email,
    required this.accessEdit,
    required this.regional,
    required this.accessList,
    required this.accessSet,
    required this.firstName,
    required this.imagesCount,
    required this.lastName,
    required this.lastUpload,
    required this.middleName,
    required this.role,
  });

  factory AEUser.fromFirestore(Map<String, dynamic>? data, String uid) {
    if (data == null) throw Exception('User data is null');

    final roleString = data['role'] as String? ?? 'worker';
    final role = roleString == 'admin' ? UserRole.admin : UserRole.worker;

    return AEUser(
      uid: uid,
      email: data['email'] as String? ?? '',
      accessEdit: data['accessEdit'] as String? ?? '',
      regional: data['regional'] as String,
      accessList: List<String>.from(data['accessList'] ?? []),
      accessSet: data['accessSet'] as String? ?? '',
      firstName: data['firstName'] as String? ?? '',
      imagesCount: data['imagesCount'] as int? ?? 0,
      lastName: data['lastName'] as String? ?? '',
      lastUpload: data['lastUpload'] as String? ?? '',
      middleName: data['middleName'] as String? ?? '',
      role: role,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'accessEdit': accessEdit,
      'regional': regional,
      'accessList': accessList, 
      'accessSet': accessSet,
      'firstName': firstName,
      'imagesCount': imagesCount,
      'lastName': lastName,
      'lastUpload': lastUpload,
      'middleName': middleName,
      'role': role == UserRole.admin ? 'admin' : 'worker',
    };
  }
}
