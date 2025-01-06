import 'package:flutter/material.dart';
import 'package:foodlink/core/constants/colors.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/models/meal.dart';
import 'package:foodlink/providers/settings_provider.dart';
import 'package:foodlink/providers/users_provider.dart';
import 'package:foodlink/screens/dashboard/widgets/custom_bottom_navigation_bar.dart';
import 'package:foodlink/screens/food_screens/widgets/plan_meal_tile.dart';
import 'package:foodlink/screens/widgets/custom_back_button.dart';
import 'package:foodlink/screens/widgets/custom_text.dart';
import 'package:foodlink/screens/widgets/image_container.dart';
import 'package:foodlink/screens/widgets/profile_circle.dart';
import 'package:foodlink/services/translation_services.dart';
import 'package:provider/provider.dart';
import '../../core/constants/assets.dart';
import '../../providers/meals_provider.dart';

class MealPlanning extends StatefulWidget {
  const MealPlanning({super.key});

  @override
  State<MealPlanning> createState() => _MealPlanningState();
}

class _MealPlanningState extends State<MealPlanning> {
  @override
  void initState() {
    MealsProvider()
        .getAllMealsByCategory(2, UsersProvider().selectedUser!.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider =
        Provider.of<SettingsProvider>(context, listen: true);
    MealsProvider mealsProvider = Provider.of<MealsProvider>(context);

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(SizeConfig.getProportionalHeight(100)),
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.getProportionalWidth(50),
                horizontal: SizeConfig.getProportionalWidth(20)),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomBackButton(),
                CustomText(
                    isCenter: true,
                    text: "meal_planning_inline",
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
                ProfileCircle(height: 50, width: 50, iconSize: 25)
              ],
            ),
          )),
      backgroundColor: AppColors.backgroundColor,
      bottomNavigationBar:
          const CustomBottomNavigationBar(fromDashboard: false),
      body: Column(children: [
        ImageContainer(imageUrl: Assets.mealPlanningHeaderImage),
        Align(
          alignment: settingsProvider.language == 'en'
              ? Alignment.centerLeft
              : Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.getProportionalHeight(20),
                horizontal: SizeConfig.getProportionalWidth(20)),
            child: const CustomText(
                isCenter: false,
                text: "meal_plan",
                fontSize: 30,
                fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
            itemCount: mealsProvider.plannedMeals.length,
            itemBuilder: (ctx, index) {
              Meal selectedMeal = mealsProvider.plannedMeals[index];
              return PlanMealTile(
                  meal: mealsProvider.plannedMeals[index],
                  day: selectedMeal.day!,
                  date: selectedMeal.date!,
                  index: index,
                  mealsProvider: mealsProvider);
            })
      ]),
    );
  }
}
