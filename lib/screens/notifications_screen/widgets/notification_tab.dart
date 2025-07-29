import 'package:flutter/material.dart';
import 'package:foodlink/controllers/general_controller.dart';
import 'package:get/get.dart';
import '../../../controllers/notification_controller.dart';
import '../../../controllers/user_types.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../core/utils/size_config.dart';
import '../../../models/meal.dart';
import '../../../models/notification.dart';
import '../../../providers/meals_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../providers/users_provider.dart';
import '../../../services/translation_services.dart';
import '../../food_screens/meal_screen.dart';
import '../../widgets/custom_text.dart';
import '../missing_ingredients_screen.dart';

class NotificationsTab extends StatelessWidget {
  const NotificationsTab(
      {super.key,
      required this.notifications,
      required this.settingsProvider,
      required this.usersProvider});

  final List<Notifications> notifications;
  final SettingsProvider settingsProvider;
  final UsersProvider usersProvider;

  @override
  Widget build(BuildContext context) {
    return notifications.isEmpty
        ? const Center(
            child: CustomText(
                isCenter: true,
                text: "no_notifications",
                fontSize: 16,
                fontWeight: FontWeight.normal))
        : ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              Notifications notification = notifications[index];
              String duration = NotificationController().getDuration(
                  notification.timestamp, settingsProvider.language);

              return FutureBuilder<Meal>(
                future: notification.isMealPlanned
                    ? MealsProvider().getPlannedMealById(notification.mealId)
                    : MealsProvider().getMealById(notification.mealId),
                builder: (context, snapshot) {
                  Meal? meal = snapshot.data;
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                      strokeWidth: 4.0,
                      backgroundColor: Colors.grey[300],
                    );
                  }
                  return ListTile(
                    onTap: () {
                      if (meal == null) {
                        GeneralController().showCustomDialog(
                            context,
                            settingsProvider,
                            "meal_not_found",
                            Icons.error_outline,
                            AppColors.errorColor,
                            50);
                        return;
                      }
                      usersProvider.selectedUser!.userTypeId == UserTypes.user
                          ? Get.to(MissingIngredientsScreen(
                              notification: notification))
                          : Get.to(MealScreen(
                              meal: meal,
                              source: 'notifications',
                            ));
                    },
                    leading: settingsProvider.language == "en"
                        ? meal != null && meal.imageUrl != null
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(meal.imageUrl!))
                            : Container(
                                width: SizeConfig.getProportionalWidth(42),
                                height: SizeConfig.getProportionalHeight(42),
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.widgetsColor),
                              )
                        : null,
                    trailing: settingsProvider.language == "en"
                        ? null
                        : meal != null && meal.imageUrl != null
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(meal.imageUrl!))
                            : Container(
                                width: SizeConfig.getProportionalWidth(42),
                                height: SizeConfig.getProportionalHeight(42),
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.widgetsColor),
                              ),
                    title: RichText(
                      textAlign: settingsProvider.language == "en"
                          ? TextAlign.left
                          : TextAlign.right,
                      textDirection: settingsProvider.language == "en"
                          ? TextDirection.ltr
                          : TextDirection.rtl,
                      text: notification.isConfirmation == false
                          ? TextSpan(children: [
                              TextSpan(
                                text: TranslationService()
                                    .translate('notification_text'),
                                style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.fontColor,
                                    fontWeight: FontWeight.normal,
                                    fontFamily:
                                        AppFonts.getPrimaryFont(context)),
                              ),
                              TextSpan(
                                text: meal!.name,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.fontColor,
                                    fontWeight: FontWeight.bold,
                                    fontFamily:
                                        AppFonts.getPrimaryFont(context)),
                              ),
                              TextSpan(
                                text: settingsProvider.language == 'en'
                                    ? ','
                                    : '،',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.fontColor,
                                    fontWeight: FontWeight.normal,
                                    fontFamily:
                                        AppFonts.getPrimaryFont(context)),
                              ),
                              TextSpan(
                                text: usersProvider.selectedUser!.userTypeId ==
                                        UserTypes.user
                                    ? TranslationService()
                                        .translate('user_notification_text_2')
                                    : TranslationService().translate(
                                        'cooker_notification_text_2'),
                                style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.fontColor,
                                    fontWeight: FontWeight.normal,
                                    fontFamily:
                                        AppFonts.getPrimaryFont(context)),
                              ),
                            ])
                          : TextSpan(children: [
                              TextSpan(
                                text: settingsProvider.language == 'en'
                                    ? meal!.name
                                    : TranslationService()
                                        .translate('done_confirmation'),
                                style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.fontColor,
                                    fontWeight:
                                        settingsProvider.language == 'en'
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                    fontFamily:
                                        AppFonts.getPrimaryFont(context)),
                              ),
                              TextSpan(
                                text: settingsProvider.language == 'en'
                                    ? TranslationService()
                                        .translate('done_confirmation')
                                    : notification.mealName,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.fontColor,
                                    fontWeight:
                                        settingsProvider.language == 'en'
                                            ? FontWeight.normal
                                            : FontWeight.bold,
                                    fontFamily:
                                        AppFonts.getPrimaryFont(context)),
                              ),
                              TextSpan(
                                text: TranslationService()
                                    .translate('for_this_day'),
                                style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.fontColor,
                                    fontWeight: FontWeight.normal,
                                    fontFamily:
                                        AppFonts.getPrimaryFont(context)),
                              ),
                              TextSpan(
                                text: TranslationService()
                                    .translate('by_partner'),
                                style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.fontColor,
                                    fontWeight: FontWeight.normal,
                                    fontFamily:
                                        AppFonts.getPrimaryFont(context)),
                              ),
                            ]),
                    ),
                    subtitle: CustomText(
                      isCenter: false,
                      text: duration,
                      color: AppColors.notificationDurationColor,
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  );
                },
              );
            },
          );
  }
}
