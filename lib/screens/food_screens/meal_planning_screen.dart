import 'package:flutter/material.dart';
import 'package:foodlink/core/constants/colors.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/models/meal.dart';
import 'package:foodlink/providers/settings_provider.dart';
import 'package:foodlink/screens/dashboard/widgets/custom_bottom_navigation_bar.dart';
import 'package:foodlink/screens/food_screens/widgets/custom_changeable_color_button.dart';
import 'package:foodlink/screens/food_screens/widgets/plan_meal_tile.dart';
import 'package:foodlink/screens/widgets/custom_back_button.dart';
import 'package:foodlink/screens/widgets/custom_text.dart';
import 'package:foodlink/screens/widgets/image_container.dart';
import 'package:foodlink/screens/widgets/profile_circle.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../core/constants/assets.dart';
import '../../providers/meals_provider.dart';
import 'weekly_meals_planning_screen.dart';

class MealPlanningScreen extends StatefulWidget {
  const MealPlanningScreen({super.key});

  @override
  State<MealPlanningScreen> createState() => _MealPlanningScreenState();
}

class _MealPlanningScreenState extends State<MealPlanningScreen> {
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
                    text: "weekly_plan",
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
        ImageContainer(imageUrl: Assets.mealPlanningHeaderImage),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.getProportionalWidth(20),
              vertical: SizeConfig.getProportionalWidth(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            textDirection: settingsProvider.language == "en"
                ? TextDirection.ltr
                : TextDirection.rtl,
            children: [
              CustomChangeableColorButton(
                  tag: 'chosen', mealsProvider: mealsProvider),
              SizeConfig.customSizedBox(40, null, null),
              CustomChangeableColorButton(
                  tag: 'self', mealsProvider: mealsProvider),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.getProportionalWidth(20),
                vertical: SizeConfig.getProportionalWidth(20)),
            child: mealsProvider.chosenPressed
                ? ListView.builder(
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
                    })
                : null,
          ),
        )
      ]),
    );
  }
}
