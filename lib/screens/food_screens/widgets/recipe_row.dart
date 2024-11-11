import 'package:flutter/material.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/providers/general_provider.dart';

import '../../../controllers/meal_controller.dart';
import '../../../core/constants/assets.dart';
import '../../../models/meal.dart';

class RecipeRow extends StatelessWidget {
  const RecipeRow({super.key, required this.meal, required this.fontSize});

  final Meal meal;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    String writtenLanguage = MealController().detectLanguage(meal.ingredients);

    return GeneralProvider().language == 'en'
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(Assets.mealRecipe),
              SizeConfig.customSizedBox(
                250,
                200,
                Text(
                  maxLines: 10,
                  meal.recipe!,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: fontSize,
                      fontFamily:
                          writtenLanguage == 'en' ? 'salsa' : 'MyriadArabic'),
                ),
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizeConfig.customSizedBox(
                250,
                200,
                Text(
                  maxLines: 10,
                  meal.recipe!,
                  textAlign: TextAlign.end,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                      fontSize: fontSize,
                      fontFamily:
                          writtenLanguage == 'en' ? 'salsa' : 'MyriadArabic'),
                ),
              ),
              Image.asset(Assets.mealRecipe),
            ],
          );
  }
}
