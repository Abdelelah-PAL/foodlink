import 'package:flutter/material.dart';
import 'package:foodlink/controllers/meal_controller.dart';
import 'package:foodlink/controllers/notification_controller.dart';
import 'package:foodlink/controllers/user_types.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/providers/meals_provider.dart';
import 'package:foodlink/providers/users_provider.dart';
import 'package:foodlink/screens/food_screens/add_meal_screen.dart';
import 'package:foodlink/screens/food_screens/meals_list_screen.dart';
import 'package:foodlink/screens/food_screens/widgets/ingredients_row.dart';
import 'package:foodlink/screens/food_screens/widgets/meal_image_container.dart';
import 'package:foodlink/screens/food_screens/widgets/name_row.dart';
import 'package:foodlink/screens/food_screens/widgets/recipe_row.dart';
import 'package:foodlink/screens/widgets/custom_button.dart';
import 'package:foodlink/services/translation_services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../models/meal.dart';
import '../../providers/settings_provider.dart';
import 'check_ingredients_screen.dart';

class MealScreen extends StatelessWidget {
  const MealScreen({super.key, required this.meal});

  final Meal meal;

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    MealsProvider mealsProvider = Provider.of<MealsProvider>(context, listen: true);
    UsersProvider usersProvider = Provider.of<UsersProvider>(context, listen: true);
    return Scaffold(
      body: Column(
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
                ),
                IngredientsRow(
                  meal: meal,
                  fontSize: 20,
                  textWidth: 250,
                  maxLines: 7,
                  settingsProvider: settingsProvider,
                ),
                SizeConfig.customSizedBox(null, 20, null),
                RecipeRow(
                    meal: meal,
                    fontSize: 15,
                    settingsProvider: settingsProvider)
              ],
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(bottom: SizeConfig.getProportionalHeight(20)),
            child: usersProvider.selectedUser!.userTypeId == UserTypes.cooker ?
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                    onTap: () {
                      Get.to(MealsListScreen(
                          index: meal.categoryId - 1,
                          categoryId: meal.categoryId));
                    },
                    text: TranslationService().translate("proceed"),
                    width: 216,
                    height: 45),
                SizeConfig.customSizedBox(null, 20, null),
                CustomButton(
                    onTap: () {
                      MealsProvider().fillDataForEdition(meal);
                      Get.to(AddMealScreen(
                          categoryId: meal.categoryId,
                          isAddScreen: false,
                          meal: meal));
                    },
                    text: TranslationService().translate("edit"),
                    width: 216,
                    height: 45),
                SizeConfig.customSizedBox(null, 20, null),
                CustomButton(
                    onTap: () {
                      mealsProvider.checkboxValues = List.generate(meal.ingredients.length, (index) => false);
                      Get.to(CheckIngredientsScreen(
                        meal: meal,
                      ));
                    },
                    text: TranslationService().translate("check_ingredients"),
                    width: 216,
                    height: 45),]
            )
            :Row(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                      onTap: () {
                        Get.to(MealsListScreen(
                            index: meal.categoryId - 1,
                            categoryId: meal.categoryId));
                      },
                      text: TranslationService().translate("proceed"),
                      width: 150,
                      height: 45),
                  SizeConfig.customSizedBox(20, null, null),
                  CustomButton(
                      onTap: () async {
                       await NotificationController().addCookerNotification(meal);
                        MealController().showSuccessDialog(context, settingsProvider);
                      },
                      text: TranslationService().translate("request_meal"),
                      width: 150,
                      height: 45),
                  SizeConfig.customSizedBox(null, 20, null),
                  ]
            ),
          )
        ],
      ),
    );
  }
}
