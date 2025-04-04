import 'package:autoexplorer/repositories/users/models/user/ae_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AbstractUsersRepository {
  // Аутентификация
  Future<AEUser?> registerUser(String email, String password, AEUser userData);
  Future<AEUser?> signInUser(String email, String password);

  // Пользователи
  Future<QuerySnapshot> getUsers();
  Future<AEUser?> getUserByUid(String uid);
  Future<void> createUser(AEUser user);
  Future<void> updateUser(AEUser user);
}