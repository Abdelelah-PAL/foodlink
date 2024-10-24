import '../models/user_details.dart';
import '../services/users_services.dart';
import 'package:flutter/cupertino.dart';


class UsersProvider with ChangeNotifier {
  static final UsersProvider _instance = UsersProvider._internal();
  factory UsersProvider() => _instance;
  UsersProvider._internal();
  List<UserDetails> users = [];
  final UsersServices _us = UsersServices();
  void addUserDetails(
      String userId,
      ) async {
    await _us.addUserDetails(userId);
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

