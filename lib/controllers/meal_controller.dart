import 'package:flutter/material.dart';

class MealController {
  static final MealController _instance = MealController._internal();
  factory MealController() => _instance;
  MealController._internal();
  TextEditingController nameController = TextEditingController();
  TextEditingController ingredientsController = TextEditingController();
  TextEditingController recipeController = TextEditingController();

}
