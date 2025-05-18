import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/user_types.dart';
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
        subscriber: userDetails.subscriber,
      );
      UserDetails user = UserDetails(
          userId: userDetails.userId,
          userTypeId: UserTypes.user,
          email: userDetails.email,
          username: userDetails.usernam,
          subscriber: userDetails.subscriber);

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

  Future<UserDetails> updateUserDetails(String userId, String username,
      String email, String? imageUrl, int userTypeId) async {
    try {
      final query = await FirebaseFirestore.instance
          .collection('user_details')
          .where('user_id', isEqualTo: userId)
          .where('user_type_id', isEqualTo: userTypeId)
          .limit(1)
          .get();
      final doc = query.docs.first.reference;
      if (imageUrl != null) {
        await doc.update(
            {'username': username, 'email': email, 'image_url': imageUrl});
      } else {
        await doc.update({'username': username, 'email': email});
      }

      final updatedSnapshot = await doc.get();

      final userDetails = UserDetails.fromJson(updatedSnapshot.data()!);
      return userDetails;
    } catch (e) {
      if (kDebugMode) {
        print('Error updating user: $e');
      }
      rethrow;
    }
  }

  Future<String?> uploadImage(XFile image) async {
    try {
      final imageRef = FirebaseStorage.instance
          .ref()
          .child("profile_pictures/${image.name}");
      File file = File(image.path);
      await imageRef.putFile(file);
      String downloadURL = await imageRef.getDownloadURL();
      return downloadURL;
    } catch (ex) {
      rethrow;
    }
  }

  Future<void> deleteImage(String imageUrl) async {
    try {
      Reference ref = FirebaseStorage.instance.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> changePassword(String newPassword) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.updatePassword(newPassword);
        await FirebaseAuth.instance.signOut(); // Optional: Force re-login
        if (kDebugMode) {
          print("Password updated successfully");
        }
      } else {
        if (kDebugMode) {
          print("No user is currently signed in.");
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        if (kDebugMode) {
          print("You need to re-authenticate before changing your password.");
        }
      } else {
        if (kDebugMode) {
          print("Password update failed: ${e.message}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("An error occurred: $e");
      }
    }
  }
}
