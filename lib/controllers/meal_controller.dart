import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodlink/models/notification.dart';
import 'package:foodlink/models/user_details.dart';
import 'package:foodlink/services/meals_services.dart';
import 'package:get/get.dart';
import '../models/meal.dart';
import '../providers/meals_provider.dart';
import '../providers/users_provider.dart';
import '../screens/food_screens/meal_screen.dart';
import '../services/translation_services.dart';

class MealController {
  static final MealController _instance = MealController._internal();

  factory MealController() => _instance;

  MealController._internal();

  TextEditingController nameController = TextEditingController();
  TextEditingController ingredientsController = TextEditingController();
  TextEditingController recipeController = TextEditingController();
  MealsServices ms = MealsServices();

  String detectLanguage(String string) {
    String languageCode = 'en';

    final RegExp english = RegExp(r'^[a-zA-Z]+');
    final RegExp arabic = RegExp(r'^[\u0621-\u064A]+');

    if (english.hasMatch(string)) {
      languageCode = 'en';
    } else if (arabic.hasMatch(string)) {
      languageCode = 'ar';
    }
    return languageCode;
  }

  Future<void> addMeal(mealsProvider, categoryId) async {
    String imageUrl = '';
    if (mealsProvider.imageIsPicked) {
      imageUrl = await MealsProvider().uploadImage(mealsProvider.pickedFile);
    }
    List<String> ingredients = MealsProvider()
        .ingredientsControllers
        .map((controller) => controller.text)
        .where((text) => text.isNotEmpty)
        .toList();

    var addedMeal = await MealsProvider().addMeal(Meal(
        categoryId: categoryId,
        name: MealController().nameController.text,
        ingredients: ingredients,
        recipe: MealController().recipeController.text,
        imageUrl: imageUrl.isNotEmpty ? imageUrl : null,
        userId: UsersProvider().selectedUser!.userId));

    mealsProvider.resetValues();
    Get.to(MealScreen(meal: addedMeal));
  }

  Future<void> updateMeal(mealsProvider, meal) async {
    String imageUrl = '';
    if (mealsProvider.imageIsPicked) {
      imageUrl = await MealsProvider().uploadImage(mealsProvider.pickedFile);
    }
    List<String> ingredients = MealsProvider()
        .ingredientsControllers
        .map((controller) => controller.text)
        .where((text) => text.isNotEmpty)
        .toList();

    var updatedMeal = await MealsProvider().updateMeal(Meal(
        documentId: meal.documentId,
        categoryId: meal.categoryId,
        name: MealController().nameController.text,
        ingredients: ingredients,
        recipe: MealController().recipeController.text,
        imageUrl: imageUrl.isNotEmpty ? imageUrl : meal.imageUrl,
        userId: UsersProvider().selectedUser!.userId,
        isFavorite: meal.isFavorite));

    Get.to(MealScreen(meal: updatedMeal));
  }

  Future<void> addUserNotification(mealsProvider, Meal meal) async {
    UserDetails userToNotify = UsersProvider().loggedInUsers.firstWhere(
        (user) => user.userTypeId != UsersProvider().selectedUser!.userTypeId);

    await mealsProvider.addNotification(Notifications(
      imageUrl: meal.imageUrl,
      userId: userToNotify.userId,
      userTypeId: userToNotify.userTypeId!,
      mealName: meal.name,
      timestamp: Timestamp.now(),
    ));
  }

  Meal findMealById(meals, id) {
    Meal meal = meals.firstWhere((meal) => meal.documentId == id);
    print(meal);
    return meal;
  }
}
