import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import '../models/notification.dart';
import '../models/user_details.dart';
import '../providers/notification_provider.dart';
import '../providers/users_provider.dart';
import '../services/meals_services.dart';
import '../services/translation_services.dart';
import 'general_controller.dart';
import 'meal_controller.dart';
import 'user_types.dart';

class NotificationController {
  static final NotificationController _instance =
      NotificationController._internal();

  factory NotificationController() => _instance;

  NotificationController._internal();

  TextEditingController nameController = TextEditingController();
  TextEditingController ingredientsController = TextEditingController();
  TextEditingController recipeController = TextEditingController();
  TextEditingController addNoteController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  MealsServices ms = MealsServices();

  Future<void> addUserNotification(meal, settingsProvider, context) async {
    UserDetails userToNotify = UsersProvider()
        .loggedInUsers
        .firstWhere((user) => user.userTypeId == UserTypes.user);
    if (MealController().missingIngredients.isNotEmpty) {
      await NotificationsProvider().addNotification(Notifications(
        imageUrl: meal.imageUrl,
        userId: userToNotify.userId,
        userTypeId: userToNotify.userTypeId!,
        mealId: meal.documentId,
        mealName: meal.name,
        missingIngredients: MealController().missingIngredients,
        notes: addNoteController.text,
        seen: false,
        timestamp: Timestamp.now(),
        isMealPlanned: meal.isPlanned,
      ));
      GeneralController().showCustomDialog(
          context,
          settingsProvider,
          "notification_sent",
          Icons.check_circle,
          AppColors.successColor,
          null);
      MealController().missingIngredients.clear();
      NotificationController ().addNoteController.clear();
    }
    else {
      GeneralController().showCustomDialog(
          context,
          settingsProvider,
          "add_missing_items",
          Icons.error,
          AppColors.errorColor,
          null);
    }


  }

  Future<void> addCookerNotification(meal) async {
    UserDetails userToNotify = UsersProvider()
        .loggedInUsers
        .firstWhere((user) => user.userTypeId == UserTypes.cooker);
    await NotificationsProvider().addNotification(Notifications(
        imageUrl: meal.imageUrl,
        userId: userToNotify.userId,
        userTypeId: userToNotify.userTypeId!,
        mealId: meal.documentId,
        mealName: meal.name,
        missingIngredients: [],
        notes: null,
        seen: false,
        timestamp: Timestamp.now(),
        isMealPlanned: meal.isPlanned));
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
              TranslationService().translate("a_day");
          englishDuration = TranslationService().translate("a_day") +
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
                  TranslationService().translate("a_day");
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
}
