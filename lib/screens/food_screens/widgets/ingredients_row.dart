import 'package:flutter/material.dart';
import 'package:foodlink/core/constants/fonts.dart';
import '../../../controllers/meal_controller.dart';
import '../../../core/constants/assets.dart';
import '../../../core/utils/size_config.dart';
import '../../../models/meal.dart';
import '../../../providers/settings_provider.dart';

class IngredientsRow extends StatelessWidget {
  const IngredientsRow(
      {super.key,
      required this.meal,
      required this.fontSize,
      required this.textWidth,
      required this.maxLines,
      required this.settingsProvider});

  final Meal meal;
  final double fontSize;
  final double textWidth;
  final int maxLines;
  final SettingsProvider settingsProvider;

  @override
  Widget build(BuildContext context) {
    String writtenLanguage = MealController().detectLanguage(meal.recipe!);

    return Row(
      textDirection:
          writtenLanguage == 'en' ? TextDirection.ltr : TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(Assets.mealIngredients),
        SizeConfig.customSizedBox(10, null, null),
        SizeConfig.customSizedBox(
          textWidth,
          null,
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Text(
              meal.ingredients.join('-'),
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              textDirection: writtenLanguage == 'en'
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              textAlign: writtenLanguage == 'en'
                  ? TextAlign.left
                  : TextAlign.right,
              style: TextStyle(
                  fontSize: fontSize, fontFamily: AppFonts.getPrimaryFont(context)),
            ),
          ),
        )
      ],
    );
  }
}
