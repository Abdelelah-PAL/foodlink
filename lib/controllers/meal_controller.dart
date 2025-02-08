import 'package:flutter/material.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/providers/settings_provider.dart';
import 'package:foodlink/screens/widgets/custom_text.dart';
import 'package:foodlink/services/meals_services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import '../models/meal.dart';
import '../providers/meals_provider.dart';
import '../providers/users_provider.dart';
import '../screens/food_screens/meal_screen.dart';

class MealController {
  static final MealController _instance = MealController._internal();

  factory MealController() => _instance;

  MealController._internal();

  TextEditingController nameController = TextEditingController();
  TextEditingController ingredientsController = TextEditingController();
  TextEditingController recipeController = TextEditingController();
  TextEditingController addNoteController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController searchController = TextEditingController();


  MealsServices ms = MealsServices();

  List<String> missingIngredients = [];

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
        userId: UsersProvider().selectedUser!.userId,
        isPlanned: false));

    mealsProvider.resetValues();
    Get.to(MealScreen(
      meal: addedMeal,
      source: 'default',
    ));
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
        isFavorite: meal.isFavorite,
        isPlanned: false));

    Get.to(MealScreen(
      meal: updatedMeal,
      source: 'default',
    ));
  }

  Meal findMealById(meals, id) {
    Meal meal = meals.firstWhere((meal) => meal.documentId == id);
    return meal;
  }

  void showCustomDialog(BuildContext context, SettingsProvider settingsProvider, String text, IconData icon, Color color) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: SizeConfig.customSizedBox(
            205,
            56,
            Row(
                textDirection: settingsProvider.language == 'en'
                    ? TextDirection.ltr
                    : TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  Icon(icon, size: 30, color: color),
                  SizeConfig.customSizedBox(10, null, null),
                  CustomText(
                      isCenter: true,
                      text: text,
                      fontSize: 20,
                      fontWeight: FontWeight.normal),
                ]),
          ),
        );
      },
    );
  }

  String getDayOfWeek(DateTime date) {
    const days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ];

    return days[date.weekday - 1];
  }

  static DateTime getPreviousSaturday(DateTime date) {
    int daysToPreviousSaturday = (date.weekday - 6) % 7;
    if (daysToPreviousSaturday < 0) {
      daysToPreviousSaturday += 7;
    }

    return date.subtract(Duration(days: daysToPreviousSaturday));
  }

  String formatDate(DateTime date) {
    return intl.DateFormat('MMM d').format(date);
  }

  


}
