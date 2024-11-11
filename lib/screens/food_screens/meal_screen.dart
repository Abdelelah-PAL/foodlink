import 'package:flutter/material.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/screens/food_screens/widgets/ingredients_row.dart';
import 'package:foodlink/screens/food_screens/widgets/meal_image_container.dart';
import 'package:foodlink/screens/food_screens/widgets/name_row.dart';
import 'package:foodlink/screens/food_screens/widgets/recipe_row.dart';
import 'package:foodlink/screens/widgets/custom_button.dart';
import 'package:foodlink/services/translation_services.dart';

import '../../models/meal.dart';

class MealScreen extends StatelessWidget {
  const MealScreen({super.key, required this.meal});

  final Meal meal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MealImageContainer(isAddSource: false, meal: meal),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.getProportionalWidth(20),
              vertical: SizeConfig.getProportionalHeight(20),
            ),
            child: Column(
              children: [
                NameRow(meal: meal, fontSize: 30, textWidth: 250),
                IngredientsRow(meal: meal, fontSize: 20, textWidth: 250),
                SizeConfig.customSizedBox(null, 20, null),
                RecipeRow(meal: meal, fontSize: 15)
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomButton(
                  onTap: () {},
                  text: TranslationService().translate("followup"),
                  width: 216,
                  height: 45),
              SizeConfig.customSizedBox(null, 20, null),
              CustomButton(
                  onTap: () {},
                  text: TranslationService().translate("edit"),
                  width: 216,
                  height: 45),
              SizeConfig.customSizedBox(null, 20, null),
              CustomButton(
                  onTap: () {},
                  text: TranslationService().translate("check_ingredients"),
                  width: 216,
                  height: 45),
            ],
          )
        ],
      ),
    );
  }
}
