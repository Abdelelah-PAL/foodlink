import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodlink/controllers/user_types.dart';
import '../models/user_details.dart';




class UsersServices with ChangeNotifier {
  final _firebaseFireStore = FirebaseFirestore.instance;

  Future<void> addUserDetails(String userId) async {
    try {
      UserDetails cooker = UserDetails(
          userId: userId, userTypeId: UserTypes.cooker);
      UserDetails user = UserDetails(
          userId: userId, userTypeId: UserTypes.user);
      print(userId);

      await _firebaseFireStore.collection('user_details').add(cooker.toMap());
      await _firebaseFireStore.collection('user_details').add(user.toMap());
    }
    catch(ex) {
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