import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_details.dart';
import '../services/users_services.dart';
import 'package:flutter/cupertino.dart';

class UsersProvider with ChangeNotifier {
  static final UsersProvider _instance = UsersProvider._internal();

  factory UsersProvider() => _instance;

  UsersProvider._internal();
  UserDetails? selectedUser;

  List<UserDetails> loggedInUsers = [];
  final UsersServices _us = UsersServices();

  void addUserDetails(UserDetails userDetails) async {
    await _us.addUserDetails(userDetails);
  }

  Future<UserDetails> getUserByRoleAndId(String id, int roleId) async {
    QuerySnapshot<Map<String, dynamic>> userQuery =
        await _us.getUserByRoleAndId(id, roleId);
    UserDetails user = UserDetails(
        userId: userQuery.docs[0]['userId'],
        email: userQuery.docs[0]['email'],
        userTypeId: userQuery.docs[0]['userTypeId'],
        username: userQuery.docs[0]['username']);
    return user;
  }

  void getUsersById(String id) async {
    try{
      QuerySnapshot<Map<String, dynamic>> userQuery =
          await _us.getUsersById(id);
      for (var doc in userQuery.docs) {
        UserDetails user = UserDetails(
            userId: doc['userId'],
            email: doc['email'],
            userTypeId: doc['userTypeId'],
            username: doc['username']);
        loggedInUsers.add(user);
      }
    }
    catch(ex) {
      rethrow;
    }

    }
  UserDetails? toggleSelectedUser(int userTypeId) {
    selectedUser = loggedInUsers.firstWhere((user) => user.userTypeId == userTypeId);
    notifyListeners();
  }
  }



