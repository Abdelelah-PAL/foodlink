import 'package:flutter/material.dart';
import 'package:foodlink/controllers/meal_controller.dart';
import 'package:foodlink/core/constants/assets.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/models/meal.dart';
import 'package:foodlink/providers/meals_provider.dart';
import 'package:foodlink/screens/food_screens/widgets/custom_meal_textfield.dart';
import 'package:foodlink/screens/food_screens/widgets/meal_image_container.dart';
import 'package:foodlink/screens/widgets/custom_button.dart';
import 'package:foodlink/services/translation_services.dart';
import 'package:provider/provider.dart';
import '../../providers/users_provider.dart';

class AddMealScreen extends StatelessWidget {
  AddMealScreen({super.key, required this.categoryId});

  final int categoryId;
  MealController mealController = MealController();

  @override
  Widget build(BuildContext context) {
    MealsProvider mealsProvider = context.read<MealsProvider>();
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
                    isAddSource: true, mealsProvider: mealsProvider),
                SizeConfig.customSizedBox(null, 20, null),
                CustomMealTextField(
                  width: SizeConfig.getProportionalWidth(348),
                  height: SizeConfig.getProportionalHeight(37),
                  hintText: TranslationService().translate("meal_name"),
                  icon: Assets.mealNameIcon,
                  controller: mealController.nameController,
                  maxLines: 2,
                  iconSizeFactor: 31,
                  hintTopPadding: 10,
                  horizontalPosition: 5,
                ),
                CustomMealTextField(
                  width: SizeConfig.getProportionalWidth(348),
                  height: SizeConfig.getProportionalHeight(161),
                  hintText: TranslationService().translate("ingredients"),
                  icon: Assets.mealIngredients,
                  controller: mealController.ingredientsController,
                  maxLines: 5,
                  iconSizeFactor: 33,
                  hintTopPadding: 10,
                  horizontalPosition: 5,
                ),
                CustomMealTextField(
                  width: SizeConfig.getProportionalWidth(348),
                  height: SizeConfig.getProportionalHeight(161),
                  hintText: TranslationService().translate("recipe"),
                  icon: Assets.mealRecipe,
                  controller: mealController.recipeController,
                  maxLines: 10,
                  iconSizeFactor: 48,
                  hintTopPadding: 10,
                  horizontalPosition: 0,
                ),
                SizeConfig.customSizedBox(null, 20, null),
                CustomButton(
                  onTap: () {
                    MealsProvider().addMeal(Meal(
                        categoryId: categoryId,
                        name: mealController.nameController.text,
                        ingredients: mealController.ingredientsController.text,
                        recipe: mealController.recipeController.text,
                        imageUrl: mealsProvider.imageUrl,
                        userId: UsersProvider().selectedUser!.userId));
                  },
                  text: TranslationService().translate("confirm"),
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
