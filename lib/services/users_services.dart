import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
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
        username: userDetails.username,
      );
      UserDetails user = UserDetails(
        userId: userDetails.userId,
        userTypeId: UserTypes.user,
        email: userDetails.email,
        username: userDetails.username,
      );

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
          .where('user_type_id', isEqualTo: roleId)
          .where('user_id', isEqualTo: id)
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
          .where('user_id', isEqualTo: id)
          .get();

      return userQuery;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUsername(
      String userId, int roleId, String username) async {
    try {
      var querySnapshot = await _firebaseFireStore
          .collection('user_details')
          .where('user_type_id', isEqualTo: roleId)
          .where('user_id', isEqualTo: userId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var docId = querySnapshot.docs.first.id;
        if (querySnapshot.docs.first['username'] == null &&
            username.isNotEmpty) {
          await _firebaseFireStore
              .collection('user_details')
              .doc(docId)
              .update({
            'username': username,
          });
        }
      }
    } catch (ex) {
      rethrow;
    }
  }
}
