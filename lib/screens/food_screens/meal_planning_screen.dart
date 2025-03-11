import 'package:flutter/material.dart';
import 'package:foodlink/controllers/meal_controller.dart';
import 'package:foodlink/core/constants/colors.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/models/meal.dart';
import 'package:foodlink/providers/settings_provider.dart';
import 'package:foodlink/providers/users_provider.dart';
import 'package:foodlink/screens/dashboard/dashboard.dart';
import 'package:foodlink/screens/dashboard/widgets/custom_bottom_navigation_bar.dart';
import 'package:foodlink/screens/food_screens/widgets/custom_changeable_color_button.dart';
import 'package:foodlink/screens/food_screens/widgets/plan_meal_tile.dart';
import 'package:foodlink/screens/widgets/custom_text.dart';
import 'package:foodlink/screens/widgets/image_container.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../core/constants/assets.dart';
import '../../providers/meals_provider.dart';
import '../widgets/custom_back_button.dart';
import 'weekly_meals_planning_screen.dart';

class MealPlanningScreen extends StatefulWidget {
  const MealPlanningScreen({super.key});

  @override
  State<MealPlanningScreen> createState() => _MealPlanningScreenState();
}

class _MealPlanningScreenState extends State<MealPlanningScreen> {
  @override
  void initState() {
    super.initState();
    MealsProvider().setPlanInterval();
    MealsProvider()
        .getAllMealsByCategory(2, UsersProvider().selectedUser!.userId);
    MealsProvider().getAllWeeklyPlans(UsersProvider().selectedUser!.userId);
  }

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider =
        Provider.of<SettingsProvider>(context, listen: true);
    MealsProvider mealsProvider = Provider.of<MealsProvider>(context);

    return mealsProvider.isLoading
        ? const CircularProgressIndicator()
        : Scaffold(
            appBar: PreferredSize(
                preferredSize:
                    Size.fromHeight(SizeConfig.getProportionalHeight(135)),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: SizeConfig.getProportionalHeight(75),
                    bottom: SizeConfig.getProportionalHeight(75),
                    left: SizeConfig.getProportionalWidth(10),
                    right: SizeConfig.getProportionalWidth(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomBackButton(
                          onPressed: () => Get.to(const Dashboard(initialIndex: 0,))),
                      const CustomText(
                        isCenter: true,
                        text: "weekly_plan",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      GestureDetector(
                        onTap: () =>
                            {Get.to(const WeeklyMealsPlanningScreen())},
                        child: Container(
                          width: SizeConfig.getProportionalWidth(30),
                          height: SizeConfig.getProportionalHeight(30),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.widgetsColor),
                          child: const Icon(Icons.add),
                        ),
                      ),
                    ],
                  ),
                )),
            backgroundColor: AppColors.backgroundColor,
            bottomNavigationBar:
                const CustomBottomNavigationBar(fromDashboard: true, initialIndex: 0,),
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
                        tag: 'chosen', mealsProvider: mealsProvider, settingsProvider:settingsProvider),
                    SizeConfig.customSizedBox(40, null, null),
                    CustomChangeableColorButton(
                        tag: 'self', mealsProvider: mealsProvider, settingsProvider:settingsProvider),
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

                            Meal selectedMeal =
                                mealsProvider.plannedMeals[index];
                            return PlanMealTile(
                              meal: mealsProvider.plannedMeals[index],
                              day: selectedMeal.day!,
                              date: selectedMeal.date!,
                              index: index,
                              mealsProvider: mealsProvider,
                              settingsProvider: settingsProvider,
                            );
                          })
                      : mealsProvider.weeklyPlanList.isNotEmpty
                          ? ListView.builder(
                              itemCount: mealsProvider.weeklyPlanList.length,
                              itemBuilder: (ctx, index) {

                                DateTime date = mealsProvider
                                    .weeklyPlanList[index].entries.first.value
                                    .toDate();

                                return FutureBuilder<Meal?>(
                                  future: Future(() async {
                                    return mealsProvider.meals.firstWhereOrNull(
                                      (object) =>
                                          object.documentId ==
                                          mealsProvider
                                              .weeklyPlanList[index].keys.first,
                                    );
                                  }),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const CircularProgressIndicator();
                                    }
                                    Meal? meal = snapshot.data;
                                    if (meal != null) {
                                      return PlanMealTile(
                                        meal: meal,
                                        day:
                                            MealController().getDayOfWeek(date),
                                        date: date,
                                        index: index,
                                        mealsProvider: mealsProvider,
                                        settingsProvider: settingsProvider,
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  },
                                );
                              },
                            )
                          : const Center(
                              child: CustomText(
                                  isCenter: true,
                                  text: "choose_weekly_plan",
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                ),
              )
            ]),
          );
  }
}
