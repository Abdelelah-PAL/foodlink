import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:foodlink/models/meal.dart';
import 'package:image_picker/image_picker.dart';

class MealsServices with ChangeNotifier {
  final _firebaseFireStore = FirebaseFirestore.instance;

  Future<String?> uploadImage(XFile image) async {
    try {
      final imageRef =
          FirebaseStorage.instance.ref().child("meals_images/${image.name}");
      File file = File(image.path);
      await imageRef.putFile(file);
      String downloadURL = await imageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Failed to upload file: $e');
    }
  }

  Future<void> addMeal(Meal meal) async {
    try {
      Future<DocumentReference<Map<String, dynamic>>> addMeal() async {
        var addedMeal =
            await _firebaseFireStore.collection('meals').add(meal.toMap());
        return addedMeal;
      }
    } catch (ex) {
      rethrow;
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllMealsByCategory(
      categoryId, userId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> mealQuery = await _firebaseFireStore
          .collection('meals')
          .where('category_id', isEqualTo: categoryId)
          .where('user_id', isEqualTo: userId)
          .get();

      return mealQuery;
    } catch (e) {
      rethrow;
    }
  }
}
