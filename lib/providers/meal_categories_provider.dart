import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodlink/models/meal_category.dart';
import 'package:foodlink/services/meal_categories_services.dart';
import 'package:flutter/cupertino.dart';

class MealCategoriesProvider with ChangeNotifier {
  static final MealCategoriesProvider _instance =
      MealCategoriesProvider._internal();

  factory MealCategoriesProvider() => _instance;

  MealCategoriesProvider._internal();

  List<MealCategory> mealCategories = [];
  final MealCategoriesServices _mcs = MealCategoriesServices();
  bool isLoading = false;


  void getAllMealCategories() async {
    try {
      isLoading = true;
      notifyListeners();
      QuerySnapshot<Map<String, dynamic>> mealQuery =
          await _mcs.getAllMealCategories();
      for (var doc in mealQuery.docs) {
        MealCategory mealCategory =
            MealCategory(name: doc['name'], imageUrl: doc['image_url']);
        mealCategories.add(mealCategory);
      }
      isLoading = false;
      notifyListeners();
    } catch (ex) {
      rethrow;
    }
  }
}
