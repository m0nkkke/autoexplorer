import 'package:autoexplorer/repositories/users/abstract_users_repository.dart';
import 'package:autoexplorer/repositories/users/models/user/ae_user.dart'; // Изменено на AEUser
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsersRepository implements AbstractUsersRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  UsersRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  Future<AEUser?> registerUser(String email, String password, AEUser userData) async { 
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user!.uid;

      final user = AEUser( 
        uid: uid,
        email: email,
        accessEdit: userData.accessEdit,
        regional: userData.regional,
        accessList: userData.accessList,
        accessSet: userData.accessSet,
        firstName: userData.firstName,
        imagesCount: userData.imagesCount,
        lastName: userData.lastName,
        lastUpload: userData.lastUpload,
        middleName: userData.middleName,
        role: userData.role,
      );

      await _firestore.collection('users').doc(uid).set(user.toFirestore());

      return user;
    } catch (e) {
      throw Exception('Failed to register user: ${e.toString()}');
    }
  }

  // Авторизация пользователя
  Future<AEUser?> signInUser(String email, String password) async { 
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user!.uid;
      return await getUserByUid(uid);
    } catch (e) {
      throw Exception('Failed to sign in user: ${e.toString()}');
    }
  }

  // Получение пользователя по UID
  Future<AEUser?> getUserByUid(String uid) async { 
    try {
      final DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();

      if (doc.exists) {
        final userData = doc. data() as Map<String, dynamic>?;
        if (userData != null) {
          return AEUser.fromFirestore(userData, uid); 
        }
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch user: ${e.toString()}');
    }
  }

  // Создание пользователя в Firestore
  @override
  Future<void> createUser(AEUser user) async { 
    try {
      await _firestore.collection('users').doc(user.uid).set(user.toFirestore());
    } catch (e) {
      throw Exception('Failed to create user: ${e.toString()}');
    }
  }

  // Получение всех пользователей
  @override
  Future<QuerySnapshot> getUsers() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      return snapshot;
    } catch (e) {
      throw Exception('Failed to load users: ${e.toString()}');
    }
  }

  // Обновление пользователя
  @override
  Future<void> updateUser(AEUser user) async { 
    try {
      await _firestore.collection('users').doc(user.uid).update(user.toFirestore());
    } catch (e) {
      throw Exception('Failed to update user: ${e.toString()}');
    }
  }
}