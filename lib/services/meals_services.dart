import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:foodlink/models/meal.dart';
import 'package:foodlink/models/weekly_plan.dart';
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

  Future<List<Meal>> getAllPlannedMeals() async {
    try {
      DateTime now = DateTime.now();
      DateTime startOfDay = DateTime(now.year, now.month, now.day);
      Timestamp startTimestamp = Timestamp.fromDate(startOfDay);
      final querySnapshot = await _firebaseFireStore
          .collection('planned_meals')
          .where('date', isGreaterThanOrEqualTo: startTimestamp)
          .orderBy('date', descending: false)
          .limit(7)
          .get();

      return querySnapshot.docs.map((doc) {
        return Meal.fromJson(doc.data(), doc.id);
      }).toList();
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

  Future<Meal> updateMeal(Meal meal) async {
    try {
      await _firebaseFireStore.collection('meals').doc(meal.documentId).set(
            meal.toMap(),
            SetOptions(merge: false),
          );
      var docRef = _firebaseFireStore.collection('meals').doc(meal.documentId);
      var docSnapshot = await docRef.get();

      Meal updatedMeal = Meal.fromJson(docSnapshot.data()!, meal.documentId);
      return updatedMeal;
    } catch (ex) {
      rethrow;
    }
  }

  Future<void> deleteMeal(String docId) async {
    await _firebaseFireStore.collection('meals').doc(docId).delete();
  }

  Future<Meal> getMealById(String docId) async {
    try {
      DocumentSnapshot mealSnapshot =
          await _firebaseFireStore.collection('meals').doc(docId).get();
      return Meal.fromJson(
        mealSnapshot.data() as Map<String, dynamic>,
        mealSnapshot.id,
      );
    } catch (ex) {
      rethrow;
    }
  }
  Future<Meal> getPlannedMealById(String docId) async {
    try {
      DocumentSnapshot mealSnapshot =
      await _firebaseFireStore.collection('planned_meals').doc(docId).get();
      return Meal.fromJson(
        mealSnapshot.data() as Map<String, dynamic>,
        mealSnapshot.id,
      );
    } catch (ex) {
      rethrow;
    }
  }

  Future<WeeklyPlan> addWeeklyPlan(weeklyPlan) async {
    try {
      var addedMeal =
      await _firebaseFireStore.collection('weekly_plan').add(weeklyPlan.toMap());
      var mealSnapshot = await addedMeal.get();

      return WeeklyPlan.fromJson(mealSnapshot.data()!, addedMeal.id);
    } catch (ex) {
      rethrow;
    }
  }
}
