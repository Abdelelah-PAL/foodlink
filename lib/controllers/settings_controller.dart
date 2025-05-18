import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import '../providers/users_provider.dart';
import '../services/translation_services.dart';

class SettingsController {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmedPasswordController = TextEditingController();
  Color usernameTextFieldBorderColor = AppColors.widgetsColor;
  Color emailTextFieldBorderColor = AppColors.widgetsColor;
  Color passwordTextFieldBorderColor = AppColors.widgetsColor;
  Color confirmPasswordTextFieldBorderColor = AppColors.widgetsColor;
  bool noneIsEmpty = true;
  bool isMatched = true;
  bool passwordIsValid = true;
  String errorText = "";
  static final SettingsController _instance = SettingsController._internal();

  factory SettingsController() => _instance;

  SettingsController._internal();

  bool checkEmptyFields() {
    noneIsEmpty = usernameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmedPasswordController.text.isNotEmpty;
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

  void changeTextFieldsColors() {
    if (!noneIsEmpty) {
      if (usernameController.text.isEmpty) {
        usernameTextFieldBorderColor = AppColors.errorColor;
      } else {
        usernameTextFieldBorderColor = AppColors.widgetsColor;
      }
      if (emailController.text.isEmpty) {
        emailTextFieldBorderColor = AppColors.errorColor;
      } else {
        emailTextFieldBorderColor = AppColors.widgetsColor;
      }
      if (passwordController.text.isEmpty) {
        passwordTextFieldBorderColor = AppColors.errorColor;
      } else {
        passwordTextFieldBorderColor = AppColors.widgetsColor;
      }
      if (confirmedPasswordController.text.isEmpty) {
        confirmPasswordTextFieldBorderColor = AppColors.errorColor;
      } else {
        confirmPasswordTextFieldBorderColor = AppColors.widgetsColor;
      }
    } else if (!isMatched || !passwordIsValid) {
      usernameTextFieldBorderColor = AppColors.widgetsColor;
      emailTextFieldBorderColor = AppColors.widgetsColor;
      passwordTextFieldBorderColor = AppColors.errorColor;
      confirmPasswordTextFieldBorderColor = AppColors.errorColor;
    } else {
      errorText = "";
      usernameTextFieldBorderColor = AppColors.widgetsColor;
      emailTextFieldBorderColor = AppColors.widgetsColor;
      passwordTextFieldBorderColor = AppColors.widgetsColor;
      confirmPasswordTextFieldBorderColor = AppColors.widgetsColor;
    }
    return;
  }

  Future<void> updateUserDetails(UsersProvider usersProvider, String userId,
      String username, String email, String password, int userTypeId) async {
    usersProvider.updateUserDetails(userId, username, email, userTypeId);
    if(password != "") {
      usersProvider.changePassword(password);
    }
  }
}
