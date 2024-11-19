import 'package:flutter/material.dart';
import 'package:foodlink/controllers/meal_controller.dart';
import 'package:foodlink/core/constants/assets.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/models/meal.dart';
import 'package:foodlink/providers/meals_provider.dart';
import 'package:foodlink/screens/food_screens/meal_screen.dart';
import 'package:foodlink/screens/food_screens/widgets/custom_meal_textfield.dart';
import 'package:foodlink/screens/food_screens/widgets/meal_image_container.dart';
import 'package:foodlink/screens/widgets/custom_button.dart';
import 'package:foodlink/services/translation_services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/users_provider.dart';

class AddMealScreen extends StatefulWidget {
  const AddMealScreen(
      {super.key,
      required this.categoryId,
      required this.isAddScreen,
      this.meal});

  final int categoryId;
  final bool isAddScreen;
  final Meal? meal;

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  @override
  Widget build(BuildContext context) {
    MealsProvider mealsProvider = context.read<MealsProvider>();
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                MealImageContainer(
                    isAddSource: widget.isAddScreen,
                    mealsProvider: mealsProvider,
                    meal: widget.meal),
                SizeConfig.customSizedBox(null, 20, null),
                CustomMealTextField(
                  width: SizeConfig.getProportionalWidth(348),
                  height: SizeConfig.getProportionalHeight(37),
                  hintText: TranslationService().translate("meal_name"),
                  icon: Assets.mealNameIcon,
                  controller: MealController().nameController,
                  maxLines: 2,
                  iconSizeFactor: 31,
                  hintTopPadding: 10,
                  horizontalPosition: 5,
                  settingsProvider: settingsProvider,
                ),
                CustomMealTextField(
                  width: SizeConfig.getProportionalWidth(348),
                  height: SizeConfig.getProportionalHeight(161),
                  hintText: TranslationService().translate("ingredients"),
                  icon: Assets.mealIngredients,
                  controller: MealController().ingredientsController,
                  maxLines: 5,
                  iconSizeFactor: 33,
                  hintTopPadding: 10,
                  horizontalPosition: 5,
                  settingsProvider: settingsProvider,
                ),
                CustomMealTextField(
                  width: SizeConfig.getProportionalWidth(348),
                  height: SizeConfig.getProportionalHeight(161),
                  hintText: TranslationService().translate("recipe"),
                  icon: Assets.mealRecipe,
                  controller: MealController().recipeController,
                  maxLines: 10,
                  iconSizeFactor: 48,
                  hintTopPadding: 10,
                  horizontalPosition: 0,
                  settingsProvider: settingsProvider,
                ),
                SizeConfig.customSizedBox(null, 20, null),
                CustomButton(
                  onTap: () async {
                    widget.isAddScreen
                        ? await MealController()
                            .addMeal(mealsProvider, widget.categoryId)
                        : await MealController()
                            .updateMeal(mealsProvider, widget.meal!);
                  },
                  text: TranslationService()
                      .translate(widget.isAddScreen ? "confirm" : "edit"),
                  width: SizeConfig.getProportionalWidth(126),
                  height: SizeConfig.getProportionalHeight(45),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
