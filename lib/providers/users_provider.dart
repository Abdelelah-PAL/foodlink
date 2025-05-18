import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/user_types.dart';
import '../core/constants/colors.dart';
import '../models/user_details.dart';
import '../services/translation_services.dart';
import '../services/users_services.dart';

class UsersProvider with ChangeNotifier {
  static final UsersProvider _instance = UsersProvider._internal();

  factory UsersProvider() => _instance;

  UsersProvider._internal();

  UserDetails? selectedUser;
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
  bool cookerFirstLogin = false;
  bool userFirstLogin = false;
  bool imageIsPicked = false;
  XFile? pickedFile;
  List<UserDetails> loggedInUsers = [];
  final UsersServices _us = UsersServices();

  void addUserDetails(UserDetails userDetails) async {
    await _us.addUserDetails(userDetails);
  }

  Future<void> getUsersById(String id) async {
    try {
      QuerySnapshot<Map<String, dynamic>> userQuery =
          await _us.getUsersById(id);
      for (var doc in userQuery.docs) {
        UserDetails user = UserDetails(
          userId: doc['user_id'],
          email: doc['email'],
          userTypeId: doc['user_type_id'],
          imageUrl: doc['image_url'],
          username: doc['username'],
          subscriber: doc['subscriber'],
        );
        loggedInUsers.add(user);
        notifyListeners();
      }
    } catch (ex) {
      rethrow;
    }
  }

  void setFirstLogin(user, roleId) {
    if (user.username == null) {
      if (roleId == UserTypes.user) {
        userFirstLogin = true;
      } else {
        cookerFirstLogin = true;
      }
      notifyListeners();
    }
  }

  void toggleSelectedUser(int userTypeId) {
    selectedUser =
        loggedInUsers.firstWhere((user) => user.userTypeId == userTypeId);
    notifyListeners();
  }

  Future<UserDetails> getUserByRoleAndId(String id, int roleId) async {
    QuerySnapshot<Map<String, dynamic>> userQuery =
        await _us.getUserByRoleAndId(id, roleId);
    UserDetails user = UserDetails(
      userId: userQuery.docs[0]['user_id'],
      email: userQuery.docs[0]['email'],
      userTypeId: userQuery.docs[0]['user_type_id'],
      imageUrl: userQuery.docs[0]['image_url'],
      username: userQuery.docs[0]['username'],
      subscriber: userQuery.docs[0]['subscriber'],
    );
    return user;
  }

  Future<UserDetails> updateUserDetails(
      String userId, String username, String email, int userTypeId) async {
    String? downloadUrl;
    if (pickedFile != null) {
      downloadUrl = await _us.uploadImage(pickedFile!);
    }
    var userDetails = await _us.updateUserDetails(
        userId, username, email, downloadUrl, userTypeId);
    return userDetails;
  }

  Future<void> changePassword(String newPassword) async {
    await _us.changePassword(newPassword);
  }

  Future<void> pickImageFromSource(BuildContext context) async {
    final picker = ImagePicker();
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
              child: const Text('Gallery'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(ImageSource.camera),
              child: const Text('Camera'),
            ),
          ],
        );
      },
    );

    XFile? file = await picker.pickImage(source: source!);

    if (file != null) {
      pickedFile = XFile(file.path);
      imageIsPicked = true;
    }
    notifyListeners();
  }

  Future<String> uploadImage(image) async {
    String? downloadUrl = await _us.uploadImage(image);
    return downloadUrl!;
  }

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

  void setSettingsPassword(password) {
    passwordController.text = password;
    confirmedPasswordController.text = password;
    notifyListeners();
  }
}
