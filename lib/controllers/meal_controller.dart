import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/models/notification.dart';
import 'package:foodlink/models/user_details.dart';
import 'package:foodlink/screens/widgets/custom_text.dart';
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
  TextEditingController addNoteController = TextEditingController();
  TextEditingController noteController = TextEditingController();

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

  Future<void> addUserNotification(mealsProvider, meal) async {
    UserDetails userToNotify = UsersProvider().loggedInUsers.firstWhere(
        (user) => user.userTypeId != UsersProvider().selectedUser!.userTypeId);
    if (missingIngredients.isNotEmpty) {
      await mealsProvider.addNotification(Notifications(
        imageUrl: meal.imageUrl,
        userId: userToNotify.userId,
        userTypeId: userToNotify.userTypeId!,
        mealName: meal.name,
        missingIngredients: missingIngredients,
        timestamp: Timestamp.now(),
        notes: addNoteController.text,
      ));
    }
    MealController().missingIngredients.clear();
    MealController().addNoteController.clear();
  }

  Meal findMealById(meals, id) {
    Meal meal = meals.firstWhere((meal) => meal.documentId == id);
    return meal;
  }

  String getDuration(Timestamp notificationTime, String language) {
    Duration diff = DateTime.now().difference(notificationTime.toDate());
    int seconds = diff.inSeconds;
    int minutes = diff.inMinutes % 60;
    int hours = diff.inHours % 24;
    int days = diff.inDays;
    String englishDuration = '';
    String arabicDuration = '';
    if (days > 0) {
      switch (days) {
        case 1:
          arabicDuration = TranslationService().translate("since") +
              TranslationService().translate("day");
          englishDuration = TranslationService().translate("day") +
              TranslationService().translate("since");
          break;
        case 2:
          arabicDuration = TranslationService().translate("since") +
              TranslationService().translate("2days");
          englishDuration = TranslationService().translate("2days") +
              TranslationService().translate("since");

          break;
        default:
          String text = TranslationService().translate("duration");
          text = text.replaceFirst('{duration}', days.toString());
          arabicDuration = days < 11
              ? TranslationService().translate("since") +
                  days.toString() +
                  TranslationService().translate("days")
              : TranslationService().translate("since") +
                  days.toString() +
                  TranslationService().translate("day");
          englishDuration = days.toString() +
              TranslationService().translate("days") +
              TranslationService().translate("since");
      }
    } else if (hours > 0) {
      switch (hours) {
        case 1:
          arabicDuration = TranslationService().translate("since") +
              TranslationService().translate("hour");
          englishDuration = TranslationService().translate("hour") +
              TranslationService().translate("since");
          break;
        case 2:
          arabicDuration = TranslationService().translate("since") +
              TranslationService().translate("2hours");
          englishDuration = TranslationService().translate("2hours") +
              TranslationService().translate("since");

          break;
        default:
          String text = TranslationService().translate("duration");
          text = text.replaceFirst('{duration}', hours.toString());
          arabicDuration = hours < 11
              ? TranslationService().translate("since") +
                  hours.toString() +
                  TranslationService().translate("hours")
              : TranslationService().translate("since") +
                  hours.toString() +
                  TranslationService().translate("hour");
          englishDuration = hours.toString() +
              TranslationService().translate("hours") +
              TranslationService().translate("since");
      }
    } else if (minutes > 0) {
      switch (minutes) {
        case 1:
          arabicDuration = TranslationService().translate("since") +
              TranslationService().translate("minute");
          englishDuration = TranslationService().translate("minute") +
              TranslationService().translate("since");
          break;
        case 2:
          arabicDuration = TranslationService().translate("since") +
              TranslationService().translate("2minutes");
          englishDuration = TranslationService().translate("2minutes") +
              TranslationService().translate("since");

          break;
        default:
          String text = TranslationService().translate("duration");
          text = text.replaceFirst('{duration}', minutes.toString());
          arabicDuration = minutes < 11
              ? TranslationService().translate("since") +
                  minutes.toString() +
                  TranslationService().translate("minutes")
              : TranslationService().translate("since") +
                  minutes.toString() +
                  TranslationService().translate("minute");
          englishDuration = minutes.toString() +
              TranslationService().translate("minutes") +
              TranslationService().translate("since");
      }
    } else {
      switch (seconds) {
        case 1:
          arabicDuration = TranslationService().translate("since") +
              TranslationService().translate("second");
          englishDuration = TranslationService().translate("second") +
              TranslationService().translate("since");
          break;
        case 2:
          arabicDuration = TranslationService().translate("since") +
              TranslationService().translate("2seconds");
          englishDuration = TranslationService().translate("2seconds") +
              TranslationService().translate("since");

          break;
        default:
          String text = TranslationService().translate("duration");
          text = text.replaceFirst('{duration}', seconds.toString());
          arabicDuration = seconds < 11
              ? TranslationService().translate("since") +
                  seconds.toString() +
                  TranslationService().translate("seconds")
              : TranslationService().translate("since") +
                  seconds.toString() +
                  TranslationService().translate("second");
          englishDuration = seconds.toString() +
              TranslationService().translate("seconds") +
              TranslationService().translate("since");
      }
    }
    var duration = language == 'en' ? englishDuration : arabicDuration;

    return duration;
  }

  void showSuccessDialog(BuildContext context, settingsProvider) {
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
              children: settingsProvider.language == 'en'
                  ? [
                      const Icon(Icons.check_circle,
                          size: 30, color: Colors.green),
                      const CustomText(
                          isCenter: true,
                          text: 'notification_sent',
                          fontSize: 20,
                          fontWeight: FontWeight.normal)
                    ]
                  : [
                      const CustomText(
                          isCenter: true,
                          text: 'notification_sent',
                          fontSize: 20,
                          fontWeight: FontWeight.normal),
                      SizeConfig.customSizedBox(10, null, null),
                      const Icon(Icons.check_circle,
                          size: 30, color: Colors.green),
                    ],
            ),
          ),
        );
      },
    );
  }
}
