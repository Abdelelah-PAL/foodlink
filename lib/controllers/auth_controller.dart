import 'package:flutter/material.dart';
import 'package:foodlink/core/constants/colors.dart';
import 'package:foodlink/services/translation_services.dart';

class AuthController {
  VoidCallback? updateUI;

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmedPasswordController = TextEditingController();
  Color usernameTextFieldBorderColor = AppColors.textFieldBorderColor;
  Color emailTextFieldBorderColor = AppColors.textFieldBorderColor;
  Color passwordTextFieldBorderColor = AppColors.textFieldBorderColor;
  Color confirmPasswordTextFieldBorderColor = AppColors.textFieldBorderColor;

  bool rememberMe = true;
  String errorText = "";

  AuthController({this.updateUI});

  bool noneIsEmpty() {
    bool noneIsEmpty = confirmedPasswordController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;

    errorText = TranslationService().translate("all_fields_required");

    return noneIsEmpty;
  }

  bool isPasswordMatched() {
    bool isMatched =
        passwordController.text == confirmedPasswordController.text;

    errorText = TranslationService().translate("password_not_matched");

    return isMatched;
  }

  void changeTextFieldsColors() {
    if (!noneIsEmpty()) {
      if (usernameController.text.isEmpty) {
        usernameTextFieldBorderColor = AppColors.errorColor;
      }
      if (emailController.text.isEmpty) {
        emailTextFieldBorderColor = AppColors.errorColor;
      }
      if (passwordController.text.isEmpty) {
        passwordTextFieldBorderColor = AppColors.errorColor;
      }
      if (confirmedPasswordController.text.isEmpty) {
        confirmPasswordTextFieldBorderColor = AppColors.errorColor;
      }
    } else if (!isPasswordMatched()) {
      passwordTextFieldBorderColor = AppColors.errorColor;
      confirmPasswordTextFieldBorderColor = AppColors.errorColor;
    } else {
      errorText = "";
      usernameTextFieldBorderColor = AppColors.textFieldBorderColor;
      emailTextFieldBorderColor = AppColors.textFieldBorderColor;
      passwordTextFieldBorderColor = AppColors.textFieldBorderColor;
      confirmPasswordTextFieldBorderColor = AppColors.textFieldBorderColor;
    }

    return;
  }

  void toggleRememberMe() {
    rememberMe =!rememberMe;
  }
}
