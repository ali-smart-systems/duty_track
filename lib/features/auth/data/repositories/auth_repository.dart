import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../../../../core/constants/app_constants.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthRepository {
  AuthRepository({AuthService? service, FirebaseFirestore? firestore})
    : _service = service ?? AuthService(),
      _firestore = firestore ?? FirebaseFirestore.instance;

  final AuthService _service;
  final FirebaseFirestore _firestore;

  User? get currentUser => _service.currentUser;

  Stream<User?> authStateChanges() {
    return _service.authStateChanges();
  }

  Future<UserModel?> currentUserData() {
    return _service.getCurrentUserData();
  }

  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    final query = await _firestore
        .collection(AppConstants.usersCollection)
        .where('username', isEqualTo: username)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      throw Exception('اسم المستخدم غير موجود.');
    }

    final userDoc = query.docs.first;
    final data = userDoc.data();

    final email = data['email'] as String?;

    if (email == null || email.isEmpty) {
      throw Exception('لا يوجد بريد إلكتروني مرتبط بهذا المستخدم.');
    }

    await _service.signInWithEmailAndPassword(email: email, password: password);

    return UserModel.fromMap(data, userDoc.id);
  }

  Future<void> logout() async {
    await _service.signOut();
  }
}
