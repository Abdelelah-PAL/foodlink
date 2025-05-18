import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/user_types.dart';
import '../models/user_details.dart';
import '../services/users_services.dart';

class UsersProvider with ChangeNotifier {
  static final UsersProvider _instance = UsersProvider._internal();

  factory UsersProvider() => _instance;

  UsersProvider._internal();

  UserDetails? selectedUser;

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
      username: userQuery.docs[0]['username'],
      subscriber: userQuery.docs[0]['subscriber'],
    );
    return user;
  }

  Future<UserDetails> updateUserDetails(String userId, String username, String email, int userTypeId) async {
    String? downloadUrl = "";
    if(pickedFile != null) {
      String? downloadUrl = await _us.uploadImage(pickedFile!);
    }
    var userDetails = await _us.updateUserDetails(userId, username, email, downloadUrl, userTypeId);
    return userDetails;
  }

  void changePassword(String newPassword) async {
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
}
