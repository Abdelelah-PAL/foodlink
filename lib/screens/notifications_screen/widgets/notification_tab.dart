import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/general_controller.dart';
import '../../../controllers/notification_controller.dart';
import '../../../controllers/user_types.dart';
import '../../../core/constants/assets.dart';
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
import '../../widgets/spectrum_loader.dart';
import '../missing_ingredients_screen.dart';

class NotificationsTab extends StatefulWidget {
  const NotificationsTab({
    super.key,
    required this.notifications,
    required this.settingsProvider,
    required this.usersProvider,
  });

  final List<Notifications> notifications;
  final SettingsProvider settingsProvider;
  final UsersProvider usersProvider;

  @override
  State<NotificationsTab> createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<NotificationsTab> {
  bool isLoading = true;
  late List<Notifications> loadedNotifications;

  @override
  void initState() {
    super.initState();
    _loadAllMeals();
  }

  Future<void> _loadAllMeals() async {
    loadedNotifications = List.from(widget.notifications);

    for (var notification in loadedNotifications) {
      try {
        Meal meal;
        if (notification.isMealPlanned) {
          meal = await MealsProvider().getPlannedMealById(notification.mealId);
        } else {
          meal = await MealsProvider().getMealById(notification.mealId);
        }
        notification.meal = meal;
      } catch (e) {
        notification.meal = null; // In case meal not found or API fails
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
          child: SpectrumLoader(),
      );
    }

    if (loadedNotifications.isEmpty) {
      return const Center(
        child: CustomText(
          isCenter: true,
          text: "no_notifications",
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
      );
    }

    return ListView.builder(
      itemCount: loadedNotifications.length,
      itemBuilder: (context, index) {
        Notifications notification = loadedNotifications[index];
        String duration = NotificationController()
            .getDuration(
            notification.timestamp, widget.settingsProvider.language);

        Meal? meal = notification.meal;

        return ListTile(
          onTap: () {
            if (meal == null) {
              GeneralController().showCustomDialog(
                context,
                widget.settingsProvider,
                "meal_not_found",
                Icons.error_outline,
                AppColors.errorColor,
                50,
              );
              return;
            }
            widget.usersProvider.selectedUser!.userTypeId == UserTypes.user
                ? Get.to(MissingIngredientsScreen(notification: notification))
                : Get.to(MealScreen(
              meal: meal,
              source: 'notifications',
            ));
          },
          leading: widget.settingsProvider.language == "en"
              ? meal != null && meal.imageUrl != null
              ? CircleAvatar(backgroundImage: NetworkImage(meal.imageUrl!))
              : Container(
            width: SizeConfig.getProportionalWidth(42),
            height: SizeConfig.getProportionalHeight(42),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.widgetsColor,
            ),
            child: Image.asset(Assets.defaultNotificationImage),
          )
              : null,
          trailing: widget.settingsProvider.language == "en"
              ? null
              : meal != null && meal.imageUrl != null
              ? CircleAvatar(backgroundImage: NetworkImage(meal.imageUrl!))
              : Container(
            width: SizeConfig.getProportionalWidth(42),
            height: SizeConfig.getProportionalHeight(42),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.widgetsColor,
            ),
            child: Image.asset(Assets.defaultNotificationImage),
          ),
          title: RichText(
            textAlign: widget.settingsProvider.language == "en"
                ? TextAlign.left
                : TextAlign.right,
            textDirection: widget.settingsProvider.language == "en"
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
                  fontFamily: AppFonts.getPrimaryFont(context),
                ),
              ),
              TextSpan(
                text: meal?.name ?? '',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.fontColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppFonts.getPrimaryFont(context),
                ),
              ),
              TextSpan(
                text: widget.settingsProvider.language == 'en' ? ',' : '،',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.fontColor,
                  fontWeight: FontWeight.normal,
                  fontFamily: AppFonts.getPrimaryFont(context),
                ),
              ),
              TextSpan(
                text: widget.usersProvider.selectedUser!.userTypeId ==
                    UserTypes.user
                    ? TranslationService()
                    .translate('user_notification_text_2')
                    : TranslationService()
                    .translate('cooker_notification_text_2'),
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.fontColor,
                  fontWeight: FontWeight.normal,
                  fontFamily: AppFonts.getPrimaryFont(context),
                ),
              ),
            ])
                : TextSpan(children: [
              TextSpan(
                text: widget.settingsProvider.language == 'en'
                    ? meal?.name ?? ''
                    : TranslationService()
                    .translate('done_confirmation'),
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.fontColor,
                  fontWeight: widget.settingsProvider.language == 'en'
                      ? FontWeight.bold
                      : FontWeight.normal,
                  fontFamily: AppFonts.getPrimaryFont(context),
                ),
              ),
              TextSpan(
                text: widget.settingsProvider.language == 'en'
                    ? TranslationService()
                    .translate('done_confirmation')
                    : notification.mealName,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.fontColor,
                  fontWeight: widget.settingsProvider.language == 'en'
                      ? FontWeight.normal
                      : FontWeight.bold,
                  fontFamily: AppFonts.getPrimaryFont(context),
                ),
              ),
              TextSpan(
                text: TranslationService()
                    .translate('for_this_day'),
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.fontColor,
                  fontWeight: FontWeight.normal,
                  fontFamily: AppFonts.getPrimaryFont(context),
                ),
              ),
              TextSpan(
                text:
                TranslationService().translate('by_partner'),
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.fontColor,
                  fontWeight: FontWeight.normal,
                  fontFamily: AppFonts.getPrimaryFont(context),
                ),
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
