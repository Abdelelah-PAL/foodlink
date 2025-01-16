import 'package:flutter/material.dart';
import 'package:foodlink/core/utils/size_config.dart';
import '../../../controllers/meal_controller.dart';
import '../../../core/constants/assets.dart';
import '../../../models/meal.dart';

class RecipeRow extends StatelessWidget {
  const RecipeRow(
      {super.key,
      required this.meal,
      required this.fontSize,
      });

  final Meal meal;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    String writtenLanguage = MealController().detectLanguage(meal.recipe!);

    return  Row(
            textDirection: writtenLanguage  == 'en'
                ? TextDirection.ltr
                : TextDirection.rtl,
            mainAxisAlignment:  MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(Assets.mealRecipe),
              SizeConfig.customSizedBox(
                280,
                200,
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Text(
                    maxLines: 100,
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
              ),
            ],
          );
  }
}
