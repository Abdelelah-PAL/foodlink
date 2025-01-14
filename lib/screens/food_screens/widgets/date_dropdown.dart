import 'package:flutter/material.dart';
import 'package:foodlink/controllers/meal_controller.dart';
import 'package:foodlink/core/constants/colors.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/providers/meals_provider.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_text.dart';

class DateDropdown extends StatelessWidget {
  const DateDropdown(
      {super.key,
      required this.list,
      required this.tag,
      required this.width,
      required this.height});

  final List<String> list;
  final String tag;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    MealsProvider mealsProvider = Provider.of<MealsProvider>(context);
    return Container(
      width: SizeConfig.getProportionalWidth(width),
      height: SizeConfig.getProportionalWidth(height),
      decoration: BoxDecoration(
          color: AppColors.widgetsColor,
          borderRadius: BorderRadius.circular(8)),
      child: Center(
        child: DropdownButton<String>(
            underline: const SizedBox(),
            value: tag == 'month'
                ? mealsProvider.selectedMonth
                : mealsProvider.selectedDay,
            hint: CustomText(
                isCenter: false,
                text: tag,
                fontSize: 18,
                fontWeight: FontWeight.bold),
            items: list.map((element) {
              return DropdownMenuItem(
                value: element,
                child: CustomText(
                  isCenter: false,
                  text: element,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList(),
            onChanged: (value) {
              tag == 'month'
                  ? {
                      mealsProvider.onMonthChange(value),
                      mealsProvider.updateDays()
                    }
                  : mealsProvider.onDayChange(value);
            }),
      ),
    );
  }
}
