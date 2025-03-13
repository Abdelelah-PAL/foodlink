import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../controllers/general_controller.dart';
import '../../controllers/meal_controller.dart';
import '../../controllers/notification_controller.dart';
import '../../core/constants/assets.dart';
import '../../core/constants/colors.dart';
import '../../core/utils/size_config.dart';
import '../../models/meal.dart';
import '../../models/notification.dart';
import '../../providers/meals_provider.dart';
import '../../providers/settings_provider.dart';
import '../../services/translation_services.dart';
import '../food_screens/widgets/meal_image_container.dart';
import '../food_screens/widgets/name_row.dart';
import '../widgets/custom_app_iconic_textfield.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';
import 'widgets/missing_checkbox_tile.dart';

class MissingIngredientsScreen extends StatelessWidget {
  const MissingIngredientsScreen({super.key, required this.notification});

  final Notifications notification;

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            MealImageContainer(
                isAddSource: false,
                isUpdateSource: false,
                imageUrl: notification.imageUrl,
                mealsProvider: context.watch<MealsProvider>()),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.getProportionalHeight(20),
                horizontal: SizeConfig.getProportionalWidth(20),
              ),
              child: Column(
                children: [
                  NameRow(
                    name: notification.mealName,
                    fontSize: 20,
                    textWidth: 280,
                    settingsProvider: settingsProvider,
                    height: 70,
                    maxLines: 2,
                  ),
                  SizeConfig.customSizedBox(null, 10, null),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: SizeConfig.getProportionalWidth(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      textDirection: settingsProvider.language == 'en'
                          ? TextDirection.ltr
                          : TextDirection.rtl,
                      children: [
                        Image.asset(Assets.mealIngredients, scale: 1.3,),
                        SizeConfig.customSizedBox(10, null, null),
                        const CustomText(
                            isCenter: false,
                            text: "ingredients",
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ],
                    ),
                  ),
                  SizeConfig.customSizedBox(
                    null,
                    250,
                    ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: notification.missingIngredients.length,
                      itemBuilder: (ctx, index) {
                        if (notification.notes != null &&
                            notification.notes!.isNotEmpty) {
                          MealController().noteController.text =
                              notification.notes!;
                        }
                        return MissingCheckboxTile(
                          settingsProvider: settingsProvider,
                          notification: notification,
                          index: index,
                        );
                      },
                    ),
                  ),
                  CustomAppIconicTextField(
                    width: 263,
                    height: 79,
                    headerText: "notes",
                    icon: Assets.note,
                    controller: MealController().noteController,
                    maxLines: 7,
                    iconSizeFactor: 31,
                    settingsProvider: settingsProvider,
                    iconPadding: 10,
                    enabled: false,
                  ),
                ],
              ),
            ),
            SizeConfig.customSizedBox(null, 30, null),
            Padding(
              padding:
                  EdgeInsets.only(bottom: SizeConfig.getProportionalHeight(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                textDirection: settingsProvider.language == 'en'
                    ? TextDirection.ltr
                    : TextDirection.rtl,
                children: [
                  CustomButton(
                    onTap: () async{
                      Meal meal =  notification.isMealPlanned
                          ? await MealsProvider()
                          .getPlannedMealById(notification.mealId)
                          : await MealsProvider().getMealById(notification.mealId);
                      await NotificationController().addConfirmationNotification(meal);
                      GeneralController().showCustomDialog(
                          context,
                          settingsProvider,
                          "confirmation_sent",
                          Icons.check_circle,
                          AppColors.successColor,
                          null);
                    },
                    text: TranslationService().translate("send_confirmation"),
                    width: 137,
                    height: 50,
                    isDisabled: true,
                  ),
                  SizeConfig.customSizedBox(20, null, null),
                  CustomButton(
                    onTap: Get.back,
                    text: TranslationService().translate("ignore"),
                    width: 137,
                    height: 50,
                    isDisabled: true,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
