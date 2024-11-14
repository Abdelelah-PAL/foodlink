import 'package:flutter/material.dart';
import 'package:foodlink/providers/general_provider.dart';
import '../../../controllers/meal_controller.dart';
import '../../../core/constants/assets.dart';
import '../../../core/utils/size_config.dart';
import '../../../models/meal.dart';

class IngredientsRow extends StatelessWidget {
  const IngredientsRow({super.key, required this.meal, required this.fontSize, required this.textWidth, required this.maxLines});

  final Meal meal;
  final double fontSize;
  final double textWidth;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    String writtenLanguage = MealController().detectLanguage(meal.ingredients);
    return GeneralProvider().language == 'en'
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(Assets.mealIngredients),
              SizeConfig.customSizedBox(10, null, null),
              SizeConfig.customSizedBox(
                textWidth,
                null,
                Text(
                  meal.ingredients,
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: fontSize,
                      fontFamily:
                          writtenLanguage == 'en' ? 'salsa' : 'MyriadArabic'),
                ),
              )
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizeConfig.customSizedBox(
                textWidth,
                null,
                Text(
                  meal.ingredients,
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                      fontSize: fontSize,
                      fontFamily:
                          writtenLanguage == 'en' ? 'salsa' : 'MyriadArabic'),
                ),
              ),
              SizeConfig.customSizedBox(10, null, null),
              Image.asset(Assets.mealIngredients),
            ],
          );
  }
}
