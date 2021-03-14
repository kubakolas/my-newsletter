import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'Rest.dart';

abstract class BaseAuth {
  Future<void> signIn(String email, String password);
  Future<void> signUp(String email, String password);
  Future<void> signOut();
  Future<void> recoverPassword(String email);
  Future<void> sendPasswordResetEmail(String email);
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> signIn(String email, String password) async {
    var result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    var token = (await result.user.getIdToken()).token;
    _saveToStorage(token, email);
  }

  Future<void> signUp(String email, String password) async {
    var result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    var token = (await result.user.getIdToken()).token;
    _saveToStorage(token, email);
    await Rest().registerUser(token);
  }

  void _saveToStorage(String token, String email) async {
    var storage = FlutterSecureStorage();
    await storage.write(key: 'email', value: email);
    await storage.write(key: 'token', value: token);
  }

  Future<void> signOut() async {
    await FlutterSecureStorage().deleteAll();
    return _firebaseAuth.signOut();
  }

  Future<IdTokenResult> getUserToken() async {
    var user = await _firebaseAuth.currentUser();
    return user.getIdToken(refresh: true);
  }

  Future<void> recoverPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}