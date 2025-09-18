import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import '../core/utils/size_config.dart';
import '../models/meal.dart';
import '../providers/meals_provider.dart';
import '../providers/users_provider.dart';
import '../screens/food_screens/meal_screen.dart';
import '../screens/widgets/custom_text.dart';
import '../services/meals_services.dart';
import 'meal_types.dart';

class MealController {
  static final MealController _instance = MealController._internal();

  factory MealController() => _instance;

  MealController._internal();

  TextEditingController nameController = TextEditingController();
  TextEditingController sourceController = TextEditingController();
  TextEditingController recipeController = TextEditingController();
  TextEditingController addNoteController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  MealsServices ms = MealsServices();

  List<String> missingIngredients = [];

  Future<void> addPlannedMeal(mealsProvider, categoryId) async {
    String imageUrl = '';
    if (mealsProvider.imageIsPicked) {
      imageUrl = await MealsProvider().uploadImage(mealsProvider.pickedFile);
    }
    List<String> ingredients = MealsProvider()
        .ingredientsControllers
        .map((controller) => controller.text)
        .where((text) => text.isNotEmpty)
        .toList();
    List<String> steps = MealsProvider()
        .stepsControllers
        .map((controller) => controller.text)
        .where((text) => text.isNotEmpty)
        .toList();

    var addedMeal = await MealsProvider().addMeal(Meal(
        categoryId: categoryId,
        name: MealController().nameController.text,
        ingredients: ingredients,
        recipe: steps,
        imageUrl: imageUrl.isNotEmpty ? imageUrl : null,
        userId: UsersProvider().selectedUser!.userId,
        typeId: MealTypes.userMeal));

    mealsProvider.resetValues();
    Get.to(MealScreen(
      meal: addedMeal,
      source: 'default',
    ));
  }

  Future<void> updateMeal(mealsProvider, meal) async {
    String imageUrl = '';
    if (mealsProvider.imageIsPicked) {
      if (meal.imageUrl != null && meal.imageUrl != "") {
        await MealsProvider().deleteImage(meal.imageUrl);
      }
      imageUrl = await MealsProvider().uploadImage(mealsProvider.pickedFile);
    }
    List<String> ingredients = MealsProvider()
        .ingredientsControllers
        .map((controller) => controller.text)
        .where((text) => text.isNotEmpty)
        .toList();
    List<String> steps = MealsProvider()
        .stepsControllers
        .map((controller) => controller.text)
        .where((text) => text.isNotEmpty)
        .toList();

    var updatedMeal = await MealsProvider().updateMeal(Meal(
        documentId: meal.documentId,
        categoryId: meal.categoryId,
        name: MealController().nameController.text,
        ingredients: ingredients,
        recipe: steps,
        imageUrl: imageUrl.isNotEmpty ? imageUrl : meal.imageUrl,
        userId: UsersProvider().selectedUser!.userId,
        isFavorite: meal.isFavorite,
        typeId: MealTypes.userMeal));

    mealsProvider.resetValues();
    Get.to(MealScreen(
      meal: updatedMeal,
      source: 'default',
    ));
  }

  Meal findMealById(meals, id) {
    Meal meal = meals.firstWhere((meal) => meal.documentId == id);
    return meal;
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

  void showSuccessUploadingDialog(BuildContext context, settingsProvider, text) {
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
                mainAxisAlignment: MainAxisAlignment.center,
                textDirection: settingsProvider.language == 'en'
                    ? TextDirection.ltr
                    : TextDirection.rtl,
                children:  [
                  const Icon(Icons.check_circle, size: 30, color: Colors.green),
                  CustomText(
                      isCenter: true,
                      text: text,
                      fontSize: 20,
                      fontWeight: FontWeight.normal)
                ]),
          ),
        );
      },
    );
  }

  void showFailedAddDialog(BuildContext context, settingsProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: SizeConfig.customSizedBox(
            350,
            56,
            Row(
                textDirection: settingsProvider.language == 'en'
                    ? TextDirection.ltr
                    : TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.error, size: 30, color: Colors.green),
                  CustomText(
                      isCenter: true,
                      text: 'fill_info',
                      fontSize: 20,
                      fontWeight: FontWeight.normal)
                ]),
          ),
        );
      },
    );
  }
}
