import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../controllers/general_controller.dart';
import '../../controllers/meal_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/utils/size_config.dart';
import '../../models/meal.dart';
import '../../models/weekly_plan.dart';
import '../../providers/meals_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/users_provider.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';
import 'meal_planning_screen.dart';
import 'widgets/changeable_date.dart';
import 'widgets/day_meal_row.dart';

class WeeklyMealsPlanningScreen extends StatefulWidget {
  const WeeklyMealsPlanningScreen({super.key});

  @override
  State<WeeklyMealsPlanningScreen> createState() =>
      _WeeklyMealsPlanningScreenState();
}

class _WeeklyMealsPlanningScreenState extends State<WeeklyMealsPlanningScreen> {
  bool isDisabled = true;

  @override
  void initState() {
    MealsProvider().setDefaultDate();
    MealsProvider()
        .getAllMealsByCategory(2, UsersProvider().selectedUser!.userId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    MealsProvider mealsProvider = Provider.of<MealsProvider>(context);
    UsersProvider usersProvider = Provider.of<UsersProvider>(context);
    return mealsProvider.isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: PreferredSize(
                preferredSize:
                    Size.fromHeight(SizeConfig.getProportionalHeight(150)),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        SizeConfig.getProportionalWidth(20),
                        SizeConfig.getProportionalHeight(50),
                        SizeConfig.getProportionalWidth(20),
                        SizeConfig.getProportionalHeight(30)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomBackButton(
                          onPressed: () {
                            MealsProvider().resetDropdownValues();
                            MealsProvider().resetWeeklyPlanList();
                            Get.back();
                          },
                        ),
                        SizedBox(
                          width: SizeConfig.getProperHorizontalSpace(5),
                        ),
                        const CustomText(
                            isCenter: true,
                            text: "your_weekly_plan",
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ],
                    ),
                  ),
                )),
            body: Padding(
              padding: EdgeInsets.fromLTRB(
                  SizeConfig.getProportionalWidth(20),
                  SizeConfig.getProportionalHeight(30),
                  SizeConfig.getProportionalWidth(20),
                  SizeConfig.getProportionalHeight(30)),
              child: Column(children: [
                ChangeableDate(
                  settingsProvider: settingsProvider,
                  mealsProvider: mealsProvider,
                ),
                SizeConfig.customSizedBox(null, 35, null),
                Expanded(
                  child: Consumer<MealsProvider>(
                    builder: (ctx, mealsProvider, child) {
                      return ListView.builder(
                        itemCount: 7,
                        itemBuilder: (ctx, index) {
                          Meal? meal;
                          DateTime initialDate =
                              mealsProvider.currentStartDate!;
                          DateTime indexDate =
                              initialDate.add(Duration(days: index));
                          var dayMeal = mealsProvider.weeklyPlanList
                              .where((object) =>
                                  DateTime.fromMillisecondsSinceEpoch(
                                      object.entries.first.value.seconds *
                                          1000) ==
                                  indexDate)
                              .firstOrNull;

                          meal = dayMeal != null
                              ? mealsProvider.meals
                                  .where(
                                    (object) =>
                                        object.documentId == dayMeal.keys.first,
                                  )
                                  .firstOrNull
                              : null;

                          var dayName =
                              MealController().getDayOfWeek(indexDate);
                          return Column(
                            children: [
                              DayMealRow(
                                  day: indexDate.day,
                                  month:
                                      mealsProvider.months[indexDate.month - 1],
                                  dayName: dayName,
                                  index: index,
                                  settingsProvider: settingsProvider,
                                  mealsProvider: mealsProvider,
                                  date: indexDate,
                                  value: meal?.name),
                              if (index != 6)
                                Align(
                                  child: Padding(
                                    padding: settingsProvider.language == 'en'
                                        ? EdgeInsets.symmetric(
                                            vertical:
                                                SizeConfig.getProportionalWidth(
                                                    10))
                                        : EdgeInsets.zero,
                                    child: SizeConfig.customSizedBox(
                                        245,
                                        null,
                                        Divider(
                                          color: AppColors.defaultBorderColor,
                                          thickness: 1,
                                          indent: settingsProvider.language ==
                                                  'en'
                                              ? SizeConfig.getProportionalWidth(
                                                  75)
                                              : SizeConfig.getProportionalWidth(
                                                  0),
                                          endIndent: settingsProvider
                                                      .language ==
                                                  'en'
                                              ? SizeConfig.getProportionalWidth(
                                                  0)
                                              : SizeConfig.getProportionalWidth(
                                                  30),
                                        )),
                                  ),
                                )
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                if (!mealsProvider.currentStartDate!.isBefore(
                    MealController.getPreviousSaturday(DateTime(
                        mealsProvider.today.year,
                        mealsProvider.today.month,
                        mealsProvider.today.day))))
                  CustomButton(
                    onTap: () async {
                      if (mealsProvider.weeklyPlanList.isEmpty) {
                        if (mealsProvider.currentWeekPlan != null) {
                          await mealsProvider.deleteWeeklyPlan();
                          return;
                        } else {
                          setState(() {
                            isDisabled = false;
                          });
                          GeneralController().showCustomDialog(
                              context,
                              settingsProvider,
                              'add_plan_error',
                              Icons.error,
                              AppColors.errorColor,
                              null);
                          return;
                        }
                      }
                      setState(() {
                        isDisabled = true;
                      });
                      await mealsProvider.addWeeklyPlan(WeeklyPlan(
                          daysMeals: mealsProvider.weeklyPlanList,
                          userId: usersProvider.selectedUser!.userId,
                          intervalEndTime: mealsProvider.currentStartDate!
                              .add(const Duration(days: 6)),
                          intervalStartTime: mealsProvider.currentStartDate!));
                      await mealsProvider.getAllWeeklyPlans(
                          usersProvider.selectedUser!.userId);
                      Get.off(const MealPlanningScreen());
                    },
                    text: 'confirm',
                    width: 126,
                    height: 45,
                    isDisabled: isDisabled,
                  ),
              ]),
            ),
          );
  }
}
