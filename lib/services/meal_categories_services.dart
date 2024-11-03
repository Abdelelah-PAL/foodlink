import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodlink/controllers/user_types.dart';
import '../models/user_details.dart';

class MealCategoriesServices with ChangeNotifier {
  final _firebaseFireStore = FirebaseFirestore.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> getAllMealCategories() async {
    try {
      QuerySnapshot<Map<String, dynamic>> mealQuery = await FirebaseFirestore
          .instance
          .collection('meal_categories')
          .get();


      return mealQuery;
    } catch (e) {
      rethrow;
    }
  }
}
