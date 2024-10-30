import 'package:flutter/foundation.dart';
import 'package:foodlink/services/translation_services.dart';
import '../controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(String email,
      String password, String username) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
      );
      User? user = userCredential.user;
      await user!.updateDisplayName(username);
      await user.reload();
      user = FirebaseAuth.instance.currentUser; // Get the updated user info
      return user;
    }
    catch (ex) {
      rethrow;
    }
  }

  Future<UserCredential?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email:email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        AuthController().errorText = TranslationService().translate("user_not_found");
      } else if (e.code == 'wrong-password') {
        AuthController().errorText = TranslationService().translate("wrong_password");
      } else {
        AuthController().errorText = e.message!;
      }
    }
  }
  }
