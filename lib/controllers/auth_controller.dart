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
  bool noneIsEmpty = true;
  bool isMatched = true;

  bool rememberMe = true;
  String errorText = "";

  AuthController({this.updateUI});

  void checkEmptyFields(login) {
    if (login == false) {
      noneIsEmpty = usernameController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
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
      } else if (!isMatched) {
        passwordTextFieldBorderColor = AppColors.errorColor;
        confirmPasswordTextFieldBorderColor = AppColors.errorColor;
      } else {
        errorText = "";
        usernameTextFieldBorderColor = AppColors.textFieldBorderColor;
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
}
