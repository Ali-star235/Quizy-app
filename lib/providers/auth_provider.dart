import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum AuthState { success, weakPassword, usedEmail, userNotFound }

class AuthenticationProvider with ChangeNotifier {
  AuthState? authState;
  bool isLoading = false;
  Future<void> creatAccount({
    required String email,
    required String password,
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      authState = AuthState.success;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        authState = AuthState.weakPassword;
        notifyListeners();
      } else if (e.code == 'email-already-in-use') {
        authState = AuthState.usedEmail;
        notifyListeners();
      }
    } catch (e) {}
    isLoading = false;
    notifyListeners();
  }

  Future<void> signIn({required String email, required String password}) async {
    isLoading = true;
    notifyListeners();
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      authState = AuthState.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        authState = AuthState.userNotFound;
        notifyListeners();
      }
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> resetPassword({required String email}) async {
    isLoading = true;
    notifyListeners();
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    isLoading = false;
    notifyListeners();
  }

  void stopLoading() {
    isLoading = false;
    notifyListeners();
  }
}
