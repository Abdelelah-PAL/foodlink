import 'package:flutter/material.dart';
import 'package:foodlink/controllers/meal_controller.dart';
import 'package:foodlink/providers/general_provider.dart';
import '../../../core/constants/assets.dart';
import '../../../core/utils/size_config.dart';
import '../../../models/meal.dart';

class NameRow extends StatelessWidget {
  const NameRow({super.key, required this.meal, required this.fontSize, required this.textWidth});

  final Meal meal;
  final double fontSize;
  final double textWidth;

  @override
  Widget build(BuildContext context) {
    String writtenLanguage = MealController().detectLanguage(meal.name);
    return GeneralProvider().language == 'en'
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(Assets.mealNameIcon),
              SizeConfig.customSizedBox(10, null, null),
              SizeConfig.customSizedBox(
                textWidth,
                null,
                Text(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  meal.name,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      fontFamily: writtenLanguage == 'en'? 'salsa' : 'MyriadArabic'),
                ),
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizeConfig.customSizedBox(
                textWidth,
                null,
                Text(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  meal.name,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      fontFamily: writtenLanguage == 'en'? 'salsa' : 'MyriadArabic'),
                ),
              ),
              SizeConfig.customSizedBox(10, null, null),
              Image.asset(Assets.mealNameIcon),
            ],
          );
  }
}
