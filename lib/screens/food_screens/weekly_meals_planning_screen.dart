import 'package:flutter/material.dart';
import 'package:foodlink/controllers/meal_controller.dart';
import 'package:foodlink/providers/meals_provider.dart';
import 'package:foodlink/providers/settings_provider.dart';
import 'package:foodlink/screens/food_screens/widgets/date_dropdown.dart';
import 'package:foodlink/screens/food_screens/widgets/day_meal_row.dart';
import 'package:foodlink/screens/widgets/custom_button.dart';
import 'package:provider/provider.dart';

import '../../core/utils/size_config.dart';
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
  void dispose() {
    MealController().dayMealsControllers.map((controller) => {
      controller.clear(),
      controller.dispose(),
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    MealsProvider mealsProvider = Provider.of<MealsProvider>(context);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(SizeConfig.getProportionalHeight(100)),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusScope.of(context).unfocus(),
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
                      text: "weekly_plan",
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                  ProfileCircle(height: 50, width: 50, iconSize: 25)
                ],
              ),
            ),
          )),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.getProportionalWidth(20)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: settingsProvider.language == "en"
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              textDirection: settingsProvider.language == "en"
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              children: [
                DateDropdown(
                    list: mealsProvider.days,
                    tag: "day",
                    width: 60,
                    height: 35),
                SizeConfig.customSizedBox(20, null, null),
                DateDropdown(
                    list: mealsProvider.months,
                    tag: "month",
                    width: 75,
                    height: 35),
              ],
            ),
            SizeConfig.customSizedBox(null, 50, null),
            if (mealsProvider.dayIsPicked == true &&
                mealsProvider.monthIsPicked == true)
              Expanded(
                child: ListView.builder(
                  itemCount: 7,
                  itemBuilder: (ctx, index) {
                    DateTime initialDate = DateTime(
                        DateTime.now().year,
                        mealsProvider.months
                                .indexOf(mealsProvider.selectedMonth!) +
                            1,
                        int.parse(mealsProvider.selectedDay!));
                    DateTime futureDate =
                        initialDate.add(Duration(days: index));
                    var dayName = MealController().getDayOfWeek(futureDate);

                    return DayMealRow(
                      day: futureDate.day,
                      month: mealsProvider.months[futureDate.month - 1],
                      dayName: dayName,
                      index: index,
                    );
                  },
                ),
              ),
            SizeConfig.customSizedBox(null, 30, null),
            CustomButton(onTap: () {}, text: 'confirm', width: 126, height: 45)
          ],
        ),
      ),
    );
  }
}
