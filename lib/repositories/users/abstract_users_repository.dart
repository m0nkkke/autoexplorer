import 'package:autoexplorer/repositories/users/models/user/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AbstractUsersRepository {
  Future<QuerySnapshot> getUsers();
  Future<User?> getUserByAccessKey(String accessKey);
  Future<bool> verifyPassword(String accessKey, String password);
  Future<void> createUser(User user);
  Future<void> updateUser(User user);
}