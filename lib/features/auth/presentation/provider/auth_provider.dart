import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unite/features/auth/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum AuthStatus { unknown, unauthenticated, authenticated }

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  final FirebaseFirestore _firestore;

  StreamSubscription? _authStateSubscription;
  StreamSubscription? _userDocSubscription;

  AuthStatus status = AuthStatus.unknown;
  User? firebaseUser;
  String userRole = 'user';

  AuthProvider({required AuthService authService, FirebaseFirestore? firestore})
    : _authService = authService,
      _firestore = firestore ?? FirebaseFirestore.instance {
    _authStateSubscription = _authService.authStateChanges.listen(
      _onAuthStateChanged,
    );
  }

  Future<void> _onAuthStateChanged(User? user) async {
    if (user == null) {
      status = AuthStatus.unauthenticated;
      firebaseUser = null;
      userRole = 'user';
      _userDocSubscription?.cancel();
      notifyListeners();
    } else {
      firebaseUser = user;

      _userDocSubscription = _firestore
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .listen((userDoc) {
            if (userDoc.exists) {
              userRole = userDoc.data()?['role'] ?? 'user';
            }
            status = AuthStatus.authenticated;
            notifyListeners();
          });
    }
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    _userDocSubscription?.cancel();
    super.dispose();
  }
}
