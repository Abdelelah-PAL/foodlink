import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_details.dart';
import '../services/users_services.dart';
import 'package:flutter/cupertino.dart';

class UsersProvider with ChangeNotifier {
  static final UsersProvider _instance = UsersProvider._internal();

  factory UsersProvider() => _instance;

  UsersProvider._internal();

  List<UserDetails> users = [];
  final UsersServices _us = UsersServices();

  void addUserDetails(UserDetails userDetails) async {
    await _us.addUserDetails(userDetails);
  }

  Future<UserDetails> getUserByRoleAndId(String id, int roleId) async {
    QuerySnapshot<Map<String, dynamic>> userQuery =
        await _us.getUserByRoleAndId(id, roleId);
    UserDetails user = UserDetails(
        userId: userQuery.docs[0]!['userId'],
        email: userQuery.docs[0]!['email'],
        userTypeId: userQuery.docs[0]!['userTypeId'],
        username: userQuery.docs[0]!['username']);
    return user;
  }
// Future<void> getAllUsers() async {
//   users = await _us.getAllUsers();
// }

//   UserDetails? getSelectedUser(String email, String password) {
//     try {
//       for (var u in users) {
//         if (email == u.email && password == u.password) {
//           return u;
//         }
//       }
//     }
//     catch(ex) {
//       rethrow;
//     }
//     return null;
// }
}
