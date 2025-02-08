import 'package:flutter/material.dart';
import 'package:foodlink/controllers/meal_controller.dart';
import 'package:foodlink/controllers/notification_controller.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/providers/meals_provider.dart';
import 'package:foodlink/screens/food_screens/widgets/checkbox_tile.dart';
import 'package:foodlink/screens/food_screens/widgets/meal_image_container.dart';
import 'package:foodlink/screens/food_screens/widgets/name_row.dart';
import 'package:foodlink/screens/widgets/custom_button.dart';
import 'package:foodlink/screens/widgets/custom_text.dart';
import 'package:foodlink/services/translation_services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../core/constants/assets.dart';
import '../../core/constants/colors.dart';
import '../../models/meal.dart';
import '../../providers/settings_provider.dart';
import '../widgets/custom_app_iconic_textfield.dart';

class CheckIngredientsScreen extends StatelessWidget {
  const CheckIngredientsScreen({super.key, required this.meal});

  final Meal meal;

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    MealsProvider mealsProvider =
        Provider.of<MealsProvider>(context, listen: true);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            MealImageContainer(
                isAddSource: false,
                imageUrl: meal.imageUrl,
                mealsProvider: context.watch<MealsProvider>()),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.getProportionalWidth(20),
              ),
              child: Column(
                children: [
                  NameRow(
                    name: meal.name,
                    fontSize: 30,
                    textWidth: 250,
                    settingsProvider: settingsProvider,
                    height: 35,
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
                      itemCount: meal.ingredients.length,
                      itemBuilder: (ctx, index) {
                        return CheckboxTile(
                            text: meal.ingredients[index],
                            settingsProvider: settingsProvider,
                            mealsProvider: mealsProvider,
                            index: index,
                            ingredientsLength: meal.ingredients.length);
                      },
                    ),
                  ),
                  CustomAppIconicTextField(
                      width: 263,
                      height: 79,
                      headerText: "add_notes",
                      icon: Assets.note,
                      controller: MealController().addNoteController,
                      maxLines: 7,
                      iconSizeFactor: 31,
                      settingsProvider: settingsProvider),
                ],
              ),
            ),
            SizeConfig.customSizedBox(null, 30, null),
            if (settingsProvider.language == 'en')
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                      onTap: () {
                        NotificationController().addUserNotification(meal);
                      },
                      text: TranslationService().translate("notify"),
                      width: 137,
                      height: 45),
                  SizeConfig.customSizedBox(20, null, null),
                  CustomButton(
                      onTap: Get.back,
                      text: TranslationService().translate("back"),
                      width: 137,
                      height: 45),
                ],
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                      onTap: Get.back,
                      text: TranslationService().translate("back"),
                      width: 137,
                      height: 45),
                  SizeConfig.customSizedBox(20, null, null),
                  CustomButton(
                      onTap: () async {
                        await NotificationController()
                            .addUserNotification(meal);
                        MealController()
                            .showCustomDialog(context, settingsProvider,'notification_sent', Icons.check_circle, AppColors.successError);
                      },
                      text: TranslationService().translate("notify"),
                      width: 137,
                      height: 45),
                ],
              )
          ],
        ),
      ),
    );
  }
}
