import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/colors.dart';
import '../providers/authentication_provider.dart';
import '../providers/dashboard_provider.dart';
import '../screens/auth_screens/login_screen.dart';
import '../services/translation_services.dart';

class AuthController {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmedPasswordController = TextEditingController();
  Color emailTextFieldBorderColor = AppColors.textFieldBorderColor;
  Color passwordTextFieldBorderColor = AppColors.textFieldBorderColor;
  Color confirmPasswordTextFieldBorderColor = AppColors.textFieldBorderColor;
  bool noneIsEmpty = true;
  bool isMatched = true;
  bool passwordIsValid = true;
  bool rememberMe = true;
  String errorText = "";

  bool checkEmptyFields(login) {
    if (login == false) {
      noneIsEmpty = emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          confirmedPasswordController.text.isNotEmpty;
    } else {
      noneIsEmpty =
          emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
    }
    errorText = noneIsEmpty
        ? ""
        : TranslationService().translate("all_fields_required");
    return noneIsEmpty;
  }

  void checkMatchedPassword() {
    isMatched = passwordController.text.trim() ==
        confirmedPasswordController.text.trim();
    errorText = !isMatched
        ? TranslationService().translate("password_not_matched")
        : "";
  }

  void checkValidPassword() {
    String password = passwordController.text.trim();
    if (password.length < 6) {
      errorText = 'password_characters_long';
      passwordIsValid = false;
    } else if (!RegExp(r'[A-Z]').hasMatch(password)) {
      errorText = 'uppercase_letter_required';
      passwordIsValid = false;
    } else if (!RegExp(r'[a-z]').hasMatch(password)) {
      errorText = 'lowercase_letter_required';
      passwordIsValid = false;
    } else if (!RegExp(r'\d').hasMatch(password)) {
      errorText = 'number_required';
      passwordIsValid = false;
    } else if (!RegExp(r'[!@#\$&*~]').hasMatch(password)) {
      errorText = 'character_required';
      passwordIsValid = false;
    } else {
      errorText = "";
      passwordIsValid = true;
    }
  }

  void changeTextFieldsColors(login) {
    if (!noneIsEmpty) {
      if (emailController.text.isEmpty) {
        emailTextFieldBorderColor = AppColors.errorColor;
      } else {
        emailTextFieldBorderColor = AppColors.textFieldBorderColor;
      }
      if (passwordController.text.isEmpty) {
        passwordTextFieldBorderColor = AppColors.errorColor;
      } else {
        passwordTextFieldBorderColor = AppColors.textFieldBorderColor;
      }
      if (confirmedPasswordController.text.isEmpty) {
        confirmPasswordTextFieldBorderColor = AppColors.errorColor;
      } else {
        confirmPasswordTextFieldBorderColor = AppColors.textFieldBorderColor;
      }
    } else if (!isMatched || !passwordIsValid) {
      emailTextFieldBorderColor = AppColors.textFieldBorderColor;
      passwordTextFieldBorderColor = AppColors.errorColor;
      confirmPasswordTextFieldBorderColor = AppColors.errorColor;
    } else {
      errorText = "";
      emailTextFieldBorderColor = AppColors.textFieldBorderColor;
      passwordTextFieldBorderColor = AppColors.textFieldBorderColor;
      confirmPasswordTextFieldBorderColor = AppColors.textFieldBorderColor;
    }
    return;
  }

  void toggleRememberMe() {
    rememberMe = !rememberMe;
  }

  Future<void> saveLoginInfo(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('email', email);
    await prefs.setString('password', password);
    await prefs.setBool('saved for $email', true);
  }

  Future<Map<String, String>> getLoginInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? '';
    final password = prefs.getString('password') ?? '';
    emailController.text = email;
    passwordController.text = password;
    return {'email': email, 'password': password};
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
  }

  void logout(AuthenticationProvider authenticationProvider,
      DashboardProvider dashBoardProvider) {
    dashBoardProvider.cookerPressed = false;
    dashBoardProvider.userPressed = false;
    dashBoardProvider.selectedIndex = 0;
    authenticationProvider.logout();
    Get.to(const LoginScreen(firstScreen: false));
  }
}
