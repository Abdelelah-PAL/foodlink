import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../controllers/meal_controller.dart';
import '../../controllers/sources.dart';
import '../../core/constants/assets.dart';
import '../../core/constants/colors.dart';
import '../../core/utils/size_config.dart';
import '../../models/meal.dart';
import '../../providers/meals_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/users_provider.dart';
import '../dashboard/dashboard.dart';
import '../dashboard/widgets/custom_bottom_navigation_bar.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/custom_text.dart';
import '../widgets/image_container.dart';
import 'weekly_meals_planning_screen.dart';
import 'widgets/add_box.dart';
import 'widgets/custom_changeable_color_button.dart';
import 'widgets/plan_meal_tile.dart';

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
                    Size.fromHeight(SizeConfig.getProperVerticalSpace(6)),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: SizeConfig.getProportionalHeight(75),
                    bottom: SizeConfig.getProportionalHeight(30),
                    left: SizeConfig.getProportionalWidth(10),
                    right: SizeConfig.getProportionalWidth(10),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: CustomBackButton(
                          onPressed: () =>
                              Get.to(const Dashboard(initialIndex: 0)),
                        ),
                      ),
                      const CustomText(
                        isCenter: true,
                        text: "weekly_plan",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                )),
            backgroundColor: AppColors.backgroundColor,
            bottomNavigationBar: const CustomBottomNavigationBar(
              fromDashboard: true,
              initialIndex: 0,
            ),
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
                      source: Sources.planningMeals,
                      text: 'chosen_meal_plan_inline',
                      tag: 'chosen',
                      mealsProvider: mealsProvider,
                      settingsProvider: settingsProvider,
                    ),
                    SizeConfig.customSizedBox(40, null, null),
                    CustomChangeableColorButton(
                      source: Sources.planningMeals,
                      text: 'your_weekly_plan',
                      tag: 'self',
                      mealsProvider: mealsProvider,
                      settingsProvider: settingsProvider,
                    ),
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
                          : Center(
                              child: GestureDetector(
                                  onTap: () => {
                                        Get.to(
                                            const WeeklyMealsPlanningScreen())
                                      },
                                  child: const AddBox()),
                            ),
                ),
              )
            ]),
          );
  }
}
