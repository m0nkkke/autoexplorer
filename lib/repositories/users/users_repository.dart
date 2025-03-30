import 'package:autoexplorer/repositories/users/abstract_users_repository.dart';
import 'package:autoexplorer/repositories/users/models/user/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsersRepository implements AbstractUsersRepository {
  final FirebaseFirestore _firestore;

  UsersRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<User?> getUserByAccessKey(String accessKey) async {
    try {
      final QuerySnapshot result = await _firestore
          .collection('users')
          .where('accessKey', isEqualTo: accessKey)
          .get();

      if (result.docs.isNotEmpty) {
        final userData = result.docs.first.data() as Map<String, dynamic>;
        return User.fromFirestore(userData);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch user: ${e.toString()}');
    }
  }

  @override
  Future<bool> verifyPassword(String accessKey, String password) async {
    try {
      final user = await getUserByAccessKey(accessKey);
      if (user == null) return false;
      
      return user.password == password;
    } catch (e) {
      throw Exception('Password verification failed: ${e.toString()}');
    }
  }

  @override
  Future<void> createUser(User user) async {
    try {
      await _firestore.collection('users').doc(user.accessKey).set(user.toFirestore());
    } catch (e) {
      throw Exception('Failed to create user: ${e.toString()}');
    }
  }

  @override
  Future<QuerySnapshot> getUsers() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      return snapshot;
    } catch (e) {
      throw Exception('Failed to load users: ${e.toString()}');
    }
  }

  @override
  Future<void> updateUser(User user) async {
    try {
      await _firestore.collection('users').doc(user.accessKey).update(user.toFirestore());
    } catch (e) {
      throw Exception('Failed to update user: ${e.toString()}');
    }
  }
}
