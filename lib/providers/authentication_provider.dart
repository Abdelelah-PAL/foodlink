import 'package:flutter/cupertino.dart';
import '../services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationProvider with ChangeNotifier {
  static final AuthenticationProvider _instance = AuthenticationProvider._internal();
  factory AuthenticationProvider() => _instance;

  AuthenticationProvider._internal();

  final AuthService _authService = AuthService();
  bool isLoading = false;
  User? user;
  final String errorMessage = "";


  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    isLoading = true;
    notifyListeners();
    user = await _authService.signUpWithEmailAndPassword(email, password);
    isLoading = false;
    notifyListeners();
    return user;
  }

  Future<UserCredential?> login(String email, String password) async {
    isLoading = true;
     notifyListeners();
     var userCredential = await _authService.login(email, password);
     isLoading = false;
     notifyListeners();
     return userCredential;
  }

  Future<UserCredential?> signUpWithGoogle() async {
    isLoading = true;
    notifyListeners();
    var userCredential = await _authService.signInWithGoogle();
    isLoading = false;
    notifyListeners();
    return userCredential;
  }
  Future<void> logout() async {
    user = null;
    await _authService.logout();
  }
}
