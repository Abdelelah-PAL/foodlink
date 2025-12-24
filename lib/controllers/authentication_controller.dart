import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/colors.dart';
import '../providers/authentication_provider.dart';
import '../providers/dashboard_provider.dart';
import '../screens/authentication_screens/login_screen.dart';
import '../services/translation_services.dart';

class AuthenticationController {
  static final AuthenticationController _instance =
      AuthenticationController._internal();

  factory AuthenticationController() => _instance;

  AuthenticationController._internal();

  TextEditingController usernameController = TextEditingController();
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  TextEditingController signUpEmailController = TextEditingController();
  TextEditingController signUpPasswordController = TextEditingController();
  TextEditingController confirmedPasswordController = TextEditingController();
  TextEditingController forgotPasswordEmailController = TextEditingController();
  Color signUpEmailTextFieldBorderColor = AppColors.textFieldBorderColor;
  Color signUpPasswordTextFieldBorderColor = AppColors.textFieldBorderColor;
  Color loginEmailTextFieldBorderColor = AppColors.textFieldBorderColor;
  Color loginPasswordTextFieldBorderColor = AppColors.textFieldBorderColor;
  Color confirmPasswordTextFieldBorderColor = AppColors.textFieldBorderColor;
  bool noneIsEmpty = true;
  bool isMatched = true;
  bool passwordIsValid = true;
  bool rememberMe = true;
  String signUpErrorText = "";
  String loginErrorText = "";

  bool checkEmptyFields(login) {
    if (login == false) {
      noneIsEmpty = signUpEmailController.text.isNotEmpty &&
          signUpPasswordController.text.isNotEmpty &&
          confirmedPasswordController.text.isNotEmpty;
      signUpErrorText = noneIsEmpty
          ? ""
          : TranslationService().translate("all_fields_required");
    } else {
      noneIsEmpty = loginEmailController.text.isNotEmpty &&
          loginPasswordController.text.isNotEmpty;
      loginErrorText = noneIsEmpty
          ? ""
          : TranslationService().translate("all_fields_required");
    }

    return noneIsEmpty;
  }

  void checkMatchedPassword() {
    isMatched = signUpPasswordController.text.trim() ==
        confirmedPasswordController.text.trim();
    signUpErrorText = !isMatched
        ? TranslationService().translate("password_not_matched")
        : "";
  }

  void checkValidPassword() {
    String password = signUpPasswordController.text.trim();
    if (password.length < 6) {
      signUpErrorText = 'password_characters_long';
      passwordIsValid = false;
    } else if (!RegExp(r'[A-Z]').hasMatch(password)) {
      signUpErrorText = 'uppercase_letter_required';
      passwordIsValid = false;
    } else if (!RegExp(r'[a-z]').hasMatch(password)) {
      signUpErrorText = 'lowercase_letter_required';
      passwordIsValid = false;
    } else if (!RegExp(r'\d').hasMatch(password)) {
      signUpErrorText = 'number_required';
      passwordIsValid = false;
    } else if (!RegExp(r'[!@#\$&*~]').hasMatch(password)) {
      signUpErrorText = 'character_required';
      passwordIsValid = false;
    } else {
      signUpErrorText = "";
      passwordIsValid = true;
    }
  }

  void changeTextFieldsColors(login) {
    if (!noneIsEmpty) {
      if (login == false) {
        if (signUpEmailController.text.isEmpty) {
          signUpEmailTextFieldBorderColor = AppColors.errorColor;
        } else {
          signUpEmailTextFieldBorderColor = AppColors.textFieldBorderColor;
        }
      } else {
        if (loginEmailController.text.isEmpty) {
          loginEmailTextFieldBorderColor = AppColors.errorColor;
        } else {
          loginEmailTextFieldBorderColor = AppColors.textFieldBorderColor;
        }
      }
      if (login == false) {
        if (signUpPasswordController.text.isEmpty) {
          signUpPasswordTextFieldBorderColor = AppColors.errorColor;
        } else {
          signUpPasswordTextFieldBorderColor = AppColors.textFieldBorderColor;
        }
      } else {
        if (loginPasswordController.text.isEmpty) {
          loginPasswordTextFieldBorderColor = AppColors.errorColor;
        } else {
          loginPasswordTextFieldBorderColor = AppColors.textFieldBorderColor;
        }
      }
      if (confirmedPasswordController.text.isEmpty) {
        confirmPasswordTextFieldBorderColor = AppColors.errorColor;
      } else {
        confirmPasswordTextFieldBorderColor = AppColors.textFieldBorderColor;
      }
    } else if (!isMatched || !passwordIsValid) {
      signUpEmailTextFieldBorderColor = AppColors.textFieldBorderColor;
      signUpPasswordTextFieldBorderColor = AppColors.errorColor;
      confirmPasswordTextFieldBorderColor = AppColors.errorColor;
    } else {
      signUpErrorText = "";
      signUpEmailTextFieldBorderColor = AppColors.textFieldBorderColor;
      signUpPasswordTextFieldBorderColor = AppColors.textFieldBorderColor;
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
    loginEmailController.text = email;
    loginPasswordController.text = password;
    return {'email': email, 'password': password};
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
  }

  void logout(AuthenticationProvider authenticationProvider,
      DashboardProvider dashBoardProvider) {
    dashBoardProvider.resetValues();
    authenticationProvider.logout();

    Get.to(const LoginScreen(firstScreen: false));
  }

  void clearTextFields() {
    signUpEmailController.clear();
    signUpPasswordController.clear();
    confirmedPasswordController.clear();
  }
}
