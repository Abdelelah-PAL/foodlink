import 'package:flutter/material.dart';
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
              String duration = NotificationController().getDuration(
                  notifications[index].timestamp, settingsProvider.language);

              return ListTile(
                onTap: () async {
                  Meal meal = notifications[index].isMealPlanned
                      ? await MealsProvider()
                          .getPlannedMealById(notifications[index].mealId)
                      : await MealsProvider()
                          .getMealById(notifications[index].mealId);
                  usersProvider.selectedUser!.userTypeId == UserTypes.user
                      ? Get.to(MissingIngredientsScreen(
                          notification: notifications[index]))
                      : Get.to(MealScreen(
                          meal: meal,
                          source: 'notifications',
                        ));
                },
                leading: settingsProvider.language == "en"
                    ? notifications[index].imageUrl != null
                        ? CircleAvatar(
                            backgroundImage:
                                NetworkImage(notifications[index].imageUrl!))
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
                    : notifications[index].imageUrl != null
                        ? CircleAvatar(
                            backgroundImage:
                                NetworkImage(notifications[index].imageUrl!))
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
                  text: TextSpan(children: [
                    TextSpan(
                      text: TranslationService().translate('notification_text'),
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColors.fontColor,
                          fontWeight: FontWeight.normal,
                          fontFamily: AppFonts.getPrimaryFont(context)),
                    ),
                    TextSpan(
                      text: notifications[index].mealName,
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColors.fontColor,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFonts.getPrimaryFont(context)),
                    ),
                    TextSpan(
                      text: settingsProvider.language == 'en' ? ',' : '،',
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColors.fontColor,
                          fontWeight: FontWeight.normal,
                          fontFamily: AppFonts.getPrimaryFont(context)),
                    ),
                    TextSpan(
                      text: usersProvider.selectedUser!.userTypeId ==
                              UserTypes.user
                          ? TranslationService()
                              .translate('user_notification_text_2')
                          : TranslationService()
                              .translate('cooker_notification_text_2'),
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColors.fontColor,
                          fontWeight: FontWeight.normal,
                          fontFamily: AppFonts.getPrimaryFont(context)),
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
  }
}
