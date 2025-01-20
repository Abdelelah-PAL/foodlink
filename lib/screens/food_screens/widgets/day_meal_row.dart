import 'package:flutter/material.dart';
import 'package:foodlink/controllers/meal_controller.dart';
import 'package:foodlink/providers/settings_provider.dart';
import 'package:foodlink/screens/widgets/custom_text.dart';
import 'package:foodlink/services/translation_services.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../core/utils/size_config.dart';

class DayMealRow extends StatelessWidget {
  const DayMealRow(
      {super.key,
      required this.day,
      required this.month,
      required this.dayName,
      required this.index});

  final int day;
  final String month;
  final String dayName;
  final int index;

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    return Row(
      textDirection: settingsProvider.language == 'en'
          ? TextDirection.ltr
          : TextDirection.rtl,
      children: [
        Column(
          children: [
            CustomText(
                isCenter: true,
                text: dayName,
                fontSize: 20,
                fontWeight: FontWeight.bold),
            CustomText(
                isCenter: true,
                text:
                    '${day.toString()} ${TranslationService().translate(month)}',
                fontSize: 20,
                fontWeight: FontWeight.normal),
          ],
        ),
        SizeConfig.customSizedBox(10, null, null),
        Container(
          width: SizeConfig.getProportionalWidth(245),
          height: SizeConfig.getProportionalHeight(40),
          margin: EdgeInsets.symmetric(
              vertical: SizeConfig.getProportionalHeight(10)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: 1.0, color: AppColors.widgetsColor),
          ),
          child: TextField(
            maxLines: 2,
            controller: MealController().dayMealsControllers[index],
            textAlign: settingsProvider.language == 'en'
                ? TextAlign.left
                : TextAlign.right,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                  SizeConfig.getProportionalWidth(10),
                  SizeConfig.getProportionalHeight(2),
                  SizeConfig.getProportionalWidth(10),
                  SizeConfig.getProportionalHeight(2)),
              hintText: TranslationService().translate('insert_meal_name'),
              hintStyle: TextStyle(
                  fontSize: 20,
                  color: AppColors.hintTextColor,
                  fontFamily: AppFonts.getPrimaryFont(context)),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
