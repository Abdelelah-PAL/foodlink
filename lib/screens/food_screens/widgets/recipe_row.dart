import 'package:flutter/material.dart';
import 'package:foodlink/core/utils/size_config.dart';
import '../../../controllers/meal_controller.dart';
import '../../../core/constants/assets.dart';
import '../../../models/meal.dart';
import '../../../providers/settings_provider.dart';

class RecipeRow extends StatelessWidget {
  const RecipeRow(
      {super.key,
      required this.meal,
      required this.fontSize,
      required this.settingsProvider});

  final Meal meal;
  final double fontSize;
  final SettingsProvider settingsProvider;

  @override
  Widget build(BuildContext context) {
    String writtenLanguage = MealController().detectLanguage(meal.recipe!);

    return  Row(
            textDirection: writtenLanguage  == 'en'
                ? TextDirection.ltr
                : TextDirection.rtl,
            mainAxisAlignment: writtenLanguage == 'en'
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(Assets.mealRecipe),
              SizeConfig.customSizedBox(
                280,
                200,
                Text(
                  maxLines: 20,
                  meal.recipe!,
                  textDirection: writtenLanguage == 'en'
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                  textAlign: writtenLanguage == 'en' ? TextAlign.end : TextAlign.start,
                  style: TextStyle(
                      fontSize: fontSize,
                      fontFamily:
                          writtenLanguage == 'en' ? 'salsa' : 'MyriadArabic'),
                ),
              ),
            ],
          );
  }
}
