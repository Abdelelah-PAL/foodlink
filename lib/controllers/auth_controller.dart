import 'package:flutter/material.dart';
import 'package:foodlink/core/constants/colors.dart';
import 'package:foodlink/services/translation_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  bool rememberMe = true;
  String errorText = "";

  void checkEmptyFields(login) {
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
  }

  void checkMatchedPassword() {
    isMatched = passwordController.text == confirmedPasswordController.text;

    errorText =
        isMatched ? TranslationService().translate("password_not_matched") : "";
  }

  void changeTextFieldsColors(login) {
    if (login == false) {
      if (!noneIsEmpty) {
        if (emailController.text.isEmpty) {
          emailTextFieldBorderColor = AppColors.errorColor;
        }
        if (passwordController.text.isEmpty) {
          passwordTextFieldBorderColor = AppColors.errorColor;
        }
        if (confirmedPasswordController.text.isEmpty) {
          confirmPasswordTextFieldBorderColor = AppColors.errorColor;
        }
      } else if (!isMatched) {
        passwordTextFieldBorderColor = AppColors.errorColor;
        confirmPasswordTextFieldBorderColor = AppColors.errorColor;
      } else {
        errorText = "";
        emailTextFieldBorderColor = AppColors.textFieldBorderColor;
        passwordTextFieldBorderColor = AppColors.textFieldBorderColor;
        confirmPasswordTextFieldBorderColor = AppColors.textFieldBorderColor;
      }
    } else {
      if (!noneIsEmpty) {
        if (emailController.text.isEmpty) {
          emailTextFieldBorderColor = AppColors.errorColor;
        }
        if (passwordController.text.isEmpty) {
          passwordTextFieldBorderColor = AppColors.errorColor;
        }
      } else {
        errorText = "";
        emailTextFieldBorderColor = AppColors.textFieldBorderColor;
        passwordTextFieldBorderColor = AppColors.textFieldBorderColor;
      }
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
}
