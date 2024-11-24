import 'package:flutter/material.dart';
import 'package:foodlink/providers/meals_provider.dart';
import 'package:foodlink/screens/food_screens/meal_screen.dart';
import 'package:foodlink/screens/food_screens/widgets/list_meal_tile.dart';
import 'package:foodlink/screens/widgets/custom_text.dart';
import 'package:foodlink/services/translation_services.dart';
import 'package:get/get.dart';
import '../../../models/meal.dart';

class PlanMealTile extends StatelessWidget {
  const PlanMealTile({
    super.key,
    required this.meal,
    required this.day,
    required this.date,
    required this.index,
    required this.mealsProvider,
  });

  final Meal meal;
  final String day;
  final String date;
  final int index;
  final MealsProvider mealsProvider;

  onTap() {
    Get.to(MealScreen(meal: meal));
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        children: [
          CustomText(
              isCenter: false,
              text: TranslationService().translate(day),
              fontSize: 20,
              fontWeight: FontWeight.bold),
          CustomText(
              isCenter: false,
              text: date,
              fontSize: 18,
              fontWeight: FontWeight.normal),
        ],
      ),
      ListMealTile(meal: mealsProvider.meals[index], favorites: false),
    ]);
  }
}
