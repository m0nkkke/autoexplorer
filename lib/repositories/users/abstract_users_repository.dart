import 'package:autoexplorer/repositories/users/models/user/user.dart';

abstract class AbstractUsersRepository {
  Future<User?> getUserByAccessKey(String accessKey);
  Future<bool> verifyPassword(String accessKey, String password);
  Future<void> createUser(User user);
}