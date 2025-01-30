import 'package:flutter/material.dart';
import 'package:foodlink/controllers/meal_controller.dart';
import 'package:foodlink/core/constants/colors.dart';
import 'package:foodlink/models/weekly_plan.dart';
import 'package:foodlink/providers/meals_provider.dart';
import 'package:foodlink/providers/settings_provider.dart';
import 'package:foodlink/screens/food_screens/widgets/changeable_date.dart';
import 'package:foodlink/screens/food_screens/widgets/day_meal_row.dart';
import 'package:foodlink/screens/widgets/custom_button.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../core/utils/size_config.dart';
import '../../providers/users_provider.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/custom_text.dart';
import '../widgets/profile_circle.dart';

class WeeklyMealsPlanningScreen extends StatefulWidget {
  const WeeklyMealsPlanningScreen({super.key});

  @override
  State<WeeklyMealsPlanningScreen> createState() =>
      _WeeklyMealsPlanningScreenState();
}

class _WeeklyMealsPlanningScreenState extends State<WeeklyMealsPlanningScreen> {
  @override
  void initState() {
    MealsProvider().setDefaultDate();
    MealsProvider()
        .getAllMealsByCategory(2, UsersProvider().selectedUser!.userId);
    MealsProvider().setPlanInterval();
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
                    Size.fromHeight(SizeConfig.getProportionalHeight(135)),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.getProportionalWidth(
                          40,
                        ),
                        horizontal: SizeConfig.getProportionalWidth(20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomBackButton(
                          onPressed: () {
                           MealsProvider().resetDropdownValues();
                            Get.back();
                          },
                        ),
                        const CustomText(
                            isCenter: true,
                            text: "weekly_plan",
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                        const ProfileCircle(height: 50, width: 50, iconSize: 25)
                      ],
                    ),
                  ),
                )),
            body: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.getProportionalWidth(20)),
              child: Column(children: [
                ChangeableDate(
                  settingsProvider: settingsProvider,
                  mealsProvider: mealsProvider,
                ),
                SizeConfig.customSizedBox(20, null, null),
                SizeConfig.customSizedBox(null, 35, null),
                Expanded(
                  child: Consumer<MealsProvider>(
                    builder: (ctx, mealsProvider, child) {
                      return ListView.builder(
                        itemCount: 7,
                        itemBuilder: (ctx, index) {
                          DateTime initialDate =
                              mealsProvider.currentStartDate!;
                          DateTime futureDate =
                              initialDate.add(Duration(days: index));
                          var dayName =
                              MealController().getDayOfWeek(futureDate);
                          return Column(
                            children: [
                              DayMealRow(
                                day: futureDate.day,
                                month:
                                    mealsProvider.months[futureDate.month - 1],
                                dayName: dayName,
                                index: index,
                                settingsProvider: settingsProvider,
                                mealsProvider: mealsProvider,
                                date: futureDate,
                              ),
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
                Padding(
                  padding: EdgeInsets.only(
                      bottom: SizeConfig.getProportionalHeight(35)),
                  child: CustomButton(
                      onTap: () async{
                        await mealsProvider.addWeeklyPlan(
                          WeeklyPlan(
                              daysMeals: mealsProvider.weeklyPlanList,
                              userId:  usersProvider.selectedUser!.userId,
                              intervalEndTime:   mealsProvider.currentStartDate!.add(const Duration(days: 6)),
                              intervalStartTime: mealsProvider.currentStartDate!)
                        );

                      }, text: 'confirm', width: 126, height: 45),
                )
              ]),
            ),
          );
  }
}
