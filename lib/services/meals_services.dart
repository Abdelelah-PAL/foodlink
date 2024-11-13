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
    } catch (ex) {
      rethrow;
    }
  }

  Future<Meal> addMeal(meal) async {
    try {
      var addedMeal =
          await _firebaseFireStore.collection('meals').add(meal.toMap());
      var mealSnapshot = await addedMeal.get();

      return Meal.fromJson(mealSnapshot.data()!, addedMeal.id);
    } catch (ex) {
      rethrow;
    }
  }

  Future<List<Meal>> getAllMealsByCategory(
      int categoryId, String userId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> mealQuery = await _firebaseFireStore
          .collection('meals')
          .where('category_id', isEqualTo: categoryId)
          .where('user_id', isEqualTo: userId)
          .get();

      List<Meal> meals = mealQuery.docs.map((doc) {
        return Meal.fromJson(doc.data(), doc.id);
      }).toList();

      return meals;
    } catch (ex) {
      rethrow;
    }
  }

  Future<List<Meal>> getFavorites(String userId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> mealQuery = await _firebaseFireStore
          .collection('meals')
          .where('user_id', isEqualTo: userId)
          .where('is_favorite', isEqualTo: true)
          .get();

      List<Meal> favoriteMeals = mealQuery.docs.map((doc) {
        return Meal.fromJson(doc.data(), doc.id);
      }).toList();

      return favoriteMeals;
    } catch (ex) {
      rethrow;
    }
  }

  Future<void> toggleIsFavorite(Meal meal, bool isFavorite) async {
    try {
      await _firebaseFireStore.collection('meals').doc(meal.documentId).update({
        'is_favorite': isFavorite,
      });
    } catch (ex) {
      rethrow;
    }
  }
}
