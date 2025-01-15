import 'package:flutter/material.dart';
import 'package:foodlink/core/constants/colors.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/models/meal.dart';
import 'package:foodlink/providers/settings_provider.dart';
import 'package:foodlink/screens/dashboard/widgets/custom_bottom_navigation_bar.dart';
import 'package:foodlink/screens/food_screens/weekly_meals_planning_screen.dart';
import 'package:foodlink/screens/food_screens/widgets/plan_meal_tile.dart';
import 'package:foodlink/screens/widgets/custom_text.dart';
import 'package:foodlink/screens/widgets/profile_circle.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../providers/meals_provider.dart';

class SelfMealPlanningScreen extends StatefulWidget {
  const SelfMealPlanningScreen({super.key});

  @override
  State<SelfMealPlanningScreen> createState() => _SelfMealPlanningScreenState();
}

class _SelfMealPlanningScreenState extends State<SelfMealPlanningScreen> {
  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider =
        Provider.of<SettingsProvider>(context, listen: true);
    MealsProvider mealsProvider = Provider.of<MealsProvider>(context);

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(SizeConfig.getProportionalHeight(135)),
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.getProportionalWidth(50),
                horizontal: SizeConfig.getProportionalWidth(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => {Get.to(const WeeklyMealsPlanningScreen())},
                  child: Container(
                    width: SizeConfig.getProportionalWidth(30),
                    height: SizeConfig.getProportionalHeight(30),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: AppColors.widgetsColor),
                    child: const Icon(Icons.add),
                  ),
                ),
                const CustomText(
                    isCenter: true,
                    text: "meal_planning_inline",
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
                const ProfileCircle(
                  height: 38,
                  width: 38,
                  iconSize: 25,
                ),
              ],
            ),
          )),
      backgroundColor: AppColors.backgroundColor,
      bottomNavigationBar:
          const CustomBottomNavigationBar(fromDashboard: false),
      body: Column(children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.getProportionalWidth(20),
                vertical: SizeConfig.getProportionalWidth(20)),
            child: ListView.builder(
                itemCount: mealsProvider.plannedMeals.length,
                itemBuilder: (ctx, index) {
                  Meal selectedMeal = mealsProvider.plannedMeals[index];
                  return PlanMealTile(
                      meal: mealsProvider.plannedMeals[index],
                      day: selectedMeal.day!,
                      date: selectedMeal.date!,
                      index: index,
                      mealsProvider: mealsProvider,
                      settingsProvider: settingsProvider);
                }),
          ),
        )
      ]),
    );
  }
}
