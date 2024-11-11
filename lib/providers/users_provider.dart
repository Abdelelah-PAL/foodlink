import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodlink/controllers/user_types.dart';
import '../models/user_details.dart';
import '../services/users_services.dart';
import 'package:flutter/cupertino.dart';

class UsersProvider with ChangeNotifier {
  static final UsersProvider _instance = UsersProvider._internal();

  factory UsersProvider() => _instance;

  UsersProvider._internal();

  UserDetails? selectedUser;

  bool cookerFirstLogin = false;
  bool userFirstLogin = false;

  List<UserDetails> loggedInUsers = [];
  final UsersServices _us = UsersServices();

  void addUserDetails(UserDetails userDetails) async {
    await _us.addUserDetails(userDetails);
  }

  Future<void>getUsersById(String id) async {
    try {
      QuerySnapshot<Map<String, dynamic>> userQuery =
      await _us.getUsersById(id);
      for (var doc in userQuery.docs) {
        UserDetails user = UserDetails(
          userId: doc['user_id'],
          email: doc['email'],
          userTypeId: doc['user_type_id'],
          username: doc['username'],
        );
        loggedInUsers.add(user);
        notifyListeners();
      }

    } catch (ex) {
      rethrow;
    }
  }

  void setFirstLogin(user, roleId) {
    if(user.username == null) {
      if(roleId == UserTypes.user) {
        userFirstLogin = true;
      }
      else {
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
    );
    return user;
  }



}
