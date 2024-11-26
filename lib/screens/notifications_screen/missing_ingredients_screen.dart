import 'package:flutter/material.dart';
import 'package:foodlink/controllers/meal_controller.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/providers/meals_provider.dart';
import 'package:foodlink/screens/food_screens/widgets/meal_image_container.dart';
import 'package:foodlink/screens/food_screens/widgets/name_row.dart';
import 'package:foodlink/screens/notifications_screen/widgets/missing_checkbox_tile.dart';
import 'package:foodlink/screens/widgets/custom_app_textfield.dart';
import 'package:foodlink/screens/widgets/custom_button.dart';
import 'package:foodlink/screens/widgets/custom_text.dart';
import 'package:foodlink/services/translation_services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../core/constants/assets.dart';
import '../../models/notification.dart';
import '../../providers/settings_provider.dart';

class MissingIngredientsScreen extends StatelessWidget {
  const MissingIngredientsScreen({super.key, required this.notification});

  final Notifications notification;

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);


    return Scaffold(
      body: Column(
        children: [
          MealImageContainer(
              isAddSource: false,
              imageUrl: notification.imageUrl,
              mealsProvider: context.watch<MealsProvider>()),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.getProportionalWidth(20),
            ),
            child: Column(
              children: [
                NameRow(
                  name: notification.mealName,
                  fontSize: 30,
                  textWidth: 250,
                  settingsProvider: settingsProvider,
                ),
                SizeConfig.customSizedBox(null, 10, null),
                settingsProvider.language == 'en'
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(Assets.mealIngredients),
                          SizeConfig.customSizedBox(10, null, null),
                          const CustomText(
                              isCenter: false,
                              text: "ingredients",
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(
                              isCenter: false,
                              text: "ingredients",
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          SizeConfig.customSizedBox(10, null, null),
                          Image.asset(Assets.mealIngredients),
                        ],
                      ),
                SizeConfig.customSizedBox(
                  null,
                  250,
                  ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: notification.missingIngredients.length,
                    itemBuilder: (ctx, index) {
                      if(notification.notes !=null && notification.notes!.isNotEmpty) {
                        MealController().noteController.text = notification.notes!;
                      }
                      return MissingCheckboxTile(
                        settingsProvider: settingsProvider,
                        notification: notification,
                        index: index,
                      );
                    },
                  ),
                ),
                CustomAppTextField(
                    width: 263,
                    height: 79,
                    headerText: "notes",
                    icon: Assets.note,
                    controller: MealController().noteController,
                    maxLines: 7,
                    iconSizeFactor: 31,
                    settingsProvider: settingsProvider),
              ],
            ),
          ),


          SizeConfig.customSizedBox(null, 30, null),
          settingsProvider.language == 'en'
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                        onTap: () {},
                        text:
                            TranslationService().translate("send_confirmation"),
                        width: 137,
                        height: 45),
                    SizeConfig.customSizedBox(20, null, null),
                    CustomButton(
                        onTap: Get.back,
                        text: TranslationService().translate("ignore"),
                        width: 137,
                        height: 45),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                        onTap: Get.back,
                        text: TranslationService().translate("ignore"),
                        width: 137,
                        height: 45),
                    SizeConfig.customSizedBox(20, null, null),
                    CustomButton(
                        onTap: () async {},
                        text:
                            TranslationService().translate("send_confirmation"),
                        width: 137,
                        height: 45),
                  ],
                ),
        ],
      ),
    );
  }
}
