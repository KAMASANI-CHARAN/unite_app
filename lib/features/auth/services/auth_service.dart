import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthService({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user == null) {
        throw Exception('Sign in failed: User not found.');
      }
      return await _fetchUserRole(user.uid);
    } on FirebaseAuthException catch (e) {
      throw Exception('Sign in failed: ${e.message}');
    }
  }

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user == null) {
        throw Exception('Sign up failed: Could not create user.');
      }
      await _createUserProfile(user.uid, fullName, email);
    } on FirebaseAuthException catch (e) {
      throw Exception('Sign up failed: ${e.message}');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String> _fetchUserRole(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.data()?['role'] ?? 'user';
    } catch (e) {
      return 'user';
    }
  }

  Future<void> _createUserProfile(
    String uid,
    String fullName,
    String email,
  ) async {
    await _firestore.collection('users').doc(uid).set({
      'fullName': fullName,
      'fullName_lowercase': fullName.toLowerCase(),
      'email': email,
      'role': 'user',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
