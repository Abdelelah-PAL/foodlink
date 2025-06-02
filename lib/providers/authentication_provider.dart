import 'package:flutter/cupertino.dart';
import 'package:foodlink/controllers/authentication_controller.dart';
import 'package:foodlink/core/constants/colors.dart';
import 'package:foodlink/services/translation_services.dart';
import '../services/authentication_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationProvider with ChangeNotifier {
  static final AuthenticationProvider _instance = AuthenticationProvider._internal();
  factory AuthenticationProvider() => _instance;

  AuthenticationProvider._internal();

  final AuthenticationServices _authService = AuthenticationServices();
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
  Future<void> sendPasswordResetEmail(email) async {
    await _authService.sendPasswordResetEmail(email);
  }

  Future<void> resetSignUpErrorText() async {
    AuthenticationController().signUpErrorText = "";
    AuthenticationController().signUpEmailTextFieldBorderColor = AppColors.textFieldBorderColor;
    AuthenticationController().signUpPasswordTextFieldBorderColor = AppColors.textFieldBorderColor;
    AuthenticationController().confirmPasswordTextFieldBorderColor = AppColors.textFieldBorderColor;
    notifyListeners();
  }

  Future<void> resetLoginErrorText() async {
    AuthenticationController().loginEmailTextFieldBorderColor = AppColors.textFieldBorderColor;
    AuthenticationController().loginPasswordTextFieldBorderColor = AppColors.textFieldBorderColor;
    AuthenticationController().loginErrorText = "";
    notifyListeners();
  }
  void setSignUpErrorText(String key) async {
    AuthenticationController().signUpErrorText = TranslationService().translate(key);
    notifyListeners();
  }

  void setLoginErrorText(String key) async {
    AuthenticationController().loginErrorText = TranslationService().translate(key);
    notifyListeners();
  }

}
