import 'package:flutter/material.dart';
import 'package:foodlink/controllers/meal_controller.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/providers/meals_provider.dart';
import 'package:foodlink/screens/food_screens/add_meal_screen.dart';
import 'package:foodlink/screens/food_screens/meals_list_screen.dart';
import 'package:foodlink/screens/food_screens/widgets/checkbox_tile.dart';
import 'package:foodlink/screens/food_screens/widgets/ingredients_row.dart';
import 'package:foodlink/screens/food_screens/widgets/meal_image_container.dart';
import 'package:foodlink/screens/food_screens/widgets/name_row.dart';
import 'package:foodlink/screens/food_screens/widgets/recipe_row.dart';
import 'package:foodlink/screens/widgets/custom_button.dart';
import 'package:foodlink/screens/widgets/custom_text.dart';
import 'package:foodlink/services/translation_services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../core/constants/assets.dart';
import '../../models/meal.dart';
import '../../providers/settings_provider.dart';

class CheckIngredientsScreen extends StatelessWidget {
  const CheckIngredientsScreen({super.key, required this.meal});

  final Meal meal;

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    MealsProvider mealsProvider =
        Provider.of<MealsProvider>(context, listen: true);

    return Scaffold(
      body: Column(
        children: [
          MealImageContainer(
              isAddSource: false,
              meal: meal,
              mealsProvider: context.watch<MealsProvider>()),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.getProportionalWidth(20),
            ),
            child: Column(
              children: [
                NameRow(
                  meal: meal,
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
                  221,
                  ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: meal.ingredients.length,
                    itemBuilder: (ctx, index) {
                      return CheckboxTile(
                        text: meal.ingredients[index],
                        settingsProvider: settingsProvider,
                        mealsProvider: mealsProvider,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SizeConfig.customSizedBox(null, 100, null),
          settingsProvider.language == 'en'
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                        onTap: () {},
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
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                        onTap: Get.back,
                        text: TranslationService().translate("back"),
                        width: 137,
                        height: 45),
                    SizeConfig.customSizedBox(20, null, null),
                    CustomButton(
                        onTap: () {},
                        text: TranslationService().translate("notify"),
                        width: 137,
                        height: 45),
                  ],
                )
        ],
      ),
    );
  }
}
