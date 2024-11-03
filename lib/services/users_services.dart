import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodlink/controllers/user_types.dart';
import '../models/user_details.dart';

class UsersServices with ChangeNotifier {
  final _firebaseFireStore = FirebaseFirestore.instance;


  Future<void> addUserDetails(userDetails) async {
    try {
      UserDetails cooker = UserDetails(
          userId: userDetails.userId,
          userTypeId: UserTypes.cooker,
          email: userDetails.email,
          username: userDetails.username);
      UserDetails user = UserDetails(
          userId: userDetails.userId,
          userTypeId: UserTypes.user,
          email: userDetails.email,
          username: userDetails.username);

      await _firebaseFireStore.collection('user_details').add(cooker.toMap());
      await _firebaseFireStore.collection('user_details').add(user.toMap());
    } catch (ex) {
      rethrow;
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUserByRoleAndId(
      String id, int roleId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> userQuery = await FirebaseFirestore
          .instance
          .collection('user_details')
          .where('userTypeId', isEqualTo: roleId)
          .where('userId', isEqualTo: id)
          .get();

      return userQuery;
    } catch (e) {
      rethrow;
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUsersById(String id) async {
    try {
      QuerySnapshot<Map<String, dynamic>> userQuery = await FirebaseFirestore
          .instance
          .collection('user_details')
          .where('userId', isEqualTo: id)
          .get();

      return userQuery;
    } catch (e) {
      rethrow;
    }
  }


// Future<List<UserDetails>> getAllUsers() async {
//   List<UserDetails> users = [];
//   var res = await http.get(
//     Uri.parse(
//         'https://babies-memories-default-rtdb.firebaseio.com/users.json'),
//   );
//   var allUsersJson = json.decode(res.body) as Map<String, dynamic>;
//   for (var x in allUsersJson.keys) {
//     users.add(UserDetails.fromJson(allUsersJson[x], x));
//     notifyListeners();
//   }
//   return users;
// }
}
