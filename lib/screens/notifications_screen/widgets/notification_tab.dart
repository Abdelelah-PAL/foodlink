import 'package:flutter/material.dart';
import 'package:foodlink/controllers/meal_controller.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/screens/widgets/custom_text.dart';
import 'package:foodlink/services/translation_services.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../models/meal.dart';
import '../../../models/notification.dart';
import '../../../providers/settings_provider.dart';

class NotificationsTab extends StatelessWidget {
  const NotificationsTab(
      {super.key,
      required this.notifications,
      required this.meals,
      required this.settingsProvider});

  final List<Notifications> notifications;
  final List<Meal> meals;
  final SettingsProvider settingsProvider;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        Duration diff = DateTime.now().difference(notifications[index].timestamp.toDate());


        return ListTile(
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
                text:
                    TranslationService().translate('user_notification_text_1'),
                style: TextStyle(
                    fontSize: 12,
                    color: AppColors.fontColor,
                    fontWeight: FontWeight.normal,
                    fontFamily: AppFonts.primaryFont),
              ),
              TextSpan(
                text: notifications[index].mealName,
                style: TextStyle(
                    fontSize: 12,
                    color: AppColors.fontColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFonts.primaryFont),
              ),
              TextSpan(
                text:
                    TranslationService().translate('user_notification_text_2'),
                style: TextStyle(
                    fontSize: 12,
                    color: AppColors.fontColor,
                    fontWeight: FontWeight.normal,
                    fontFamily: AppFonts.primaryFont),
              ),
            ]),
          ),
          subtitle: CustomText(
            isCenter: false,
            text: diff.toString(),
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
        );
      },
    );
  }
}
