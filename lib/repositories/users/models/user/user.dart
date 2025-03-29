import 'package:autoexplorer/repositories/users/models/accessList/access_list.dart';
import 'package:autoexplorer/repositories/users/models/user/user_role.dart';

class User {
  final String accessKey;
  final String accessEdit;
  final AccessList accessList;
  final String accessSet;
  final String firstName;
  final int imagesCount;
  final String lastName;
  final String lastUpload;
  final String middleName;
  final String password;
  final UserRole role;

  User({
    required this.accessKey,
    required this.accessEdit,
    required this.accessList,
    required this.accessSet,
    required this.firstName,
    required this.imagesCount,
    required this.lastName,
    required this.lastUpload,
    required this.middleName,
    required this.password,
    required this.role,
  });

  factory User.fromFirestore(Map<String, dynamic>? data) {
    if (data == null) throw Exception('User data is null');

    final roleString = data ['role'] as String? ?? 'worker';
    final role = roleString == 'admin' ? UserRole.admin : UserRole.worker;

    return User(
      accessKey: data['accessKey'] as String? ?? '',
      accessEdit: data['accessEdit'] as String? ?? '',
      accessList: AccessList.fromMap(data['accessList'] as Map<String, dynamic>?),
      accessSet: data['accessSet'] as String? ?? '',
      firstName: data ['firstName'] as String? ?? '',
      imagesCount: data ['imagesCount']  as int? ?? 0,
      lastName: data['lastName'] as String? ?? '',
      lastUpload: data['lastUpload'] as String? ?? '',
      middleName: data['middleName'] as String? ?? '',
      password: data['password'] as String? ?? '',
      role: role,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'accessKey': accessKey,
      'accessEdit': accessEdit,
      'accessList': accessList.toMap(),
      'accessSet': accessSet,
      'firstName': firstName,
      'imagesCount': imagesCount,
      'lastName': lastName,
      'lastUpload': lastUpload,
      'middleName': middleName,
      'password': password,
      'role': role == UserRole.admin ? 'admin' : 'worker',
    };
  }
}