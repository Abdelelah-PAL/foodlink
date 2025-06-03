import 'package:flutter/foundation.dart';
import 'package:foodlink/providers/authentication_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../controllers/authentication_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'translation_services.dart';

class AuthenticationServices with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password, AuthenticationProvider authenticationProvider) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.message != null) {
        authenticationProvider.setSignUpErrorText(e.message!);
        if (kDebugMode) {
          print("Registration failed: ${e.message}");
        }
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print("Unexpected error: $e");
      }
      rethrow;
    }
  }

  Future<UserCredential?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        AuthenticationController().loginErrorText =
            TranslationService().translate("user_not_found");
      } else if (e.code == 'wrong-password') {
        AuthenticationController().loginErrorText =
            TranslationService().translate("wrong_password");
      } else {
        AuthenticationController().loginErrorText = e.message!;
      }
      return null; // Ensure the function always returns a value
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      if (kDebugMode) {
        print("Google sign-in error: $e");
      }
      return null;
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> sendPasswordResetEmail(email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      if (kDebugMode) {
        print("Error: ${e.toString()}");
      }
      return;
    }
  }
}
