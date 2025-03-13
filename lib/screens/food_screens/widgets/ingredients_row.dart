import 'package:flutter/material.dart';
import '../../../controllers/general_controller.dart';
import '../../../core/constants/assets.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../core/utils/size_config.dart';
import '../../../models/meal.dart';
import '../../../providers/settings_provider.dart';

class IngredientsRow extends StatelessWidget {
  const IngredientsRow(
      {super.key,
      required this.meal,
      required this.fontSize,
      required this.textWidth,
      required this.maxLines,
      required this.settingsProvider,
      required this.height,
      required this.horizontalPadding,
      required this.withBorder});

  final Meal meal;
  final double fontSize;
  final double textWidth;
  final int maxLines;
  final SettingsProvider settingsProvider;
  final double height;
  final double horizontalPadding;
  final bool withBorder;

  @override
  Widget build(BuildContext context) {
    String writtenLanguage = GeneralController().detectLanguage(meal.recipe!);
    return Container(
      padding: EdgeInsets.only(
          top: SizeConfig.getProportionalHeight(10),
          left: SizeConfig.getProportionalWidth(10),
          right: SizeConfig.getProportionalWidth(10)),
      width: 348,
      height: height,
      decoration: withBorder == true
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(width: 1.0, color: AppColors.widgetsColor))
          : null,
      child: Row(
        textDirection: settingsProvider.language == 'en'
            ? TextDirection.ltr
            : TextDirection.rtl,
        mainAxisAlignment: settingsProvider.language == 'en'
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(scale: 1.3, Assets.mealIngredients),
          SizeConfig.customSizedBox(10, null, null),
          Expanded(
            child: SizeConfig.customSizedBox(
              textWidth,
              null,
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Text(
                  meal.ingredients.join(' - '),
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                  textAlign:
                  settingsProvider.language == 'en' ? TextAlign.end : TextAlign.start,
                  textDirection: writtenLanguage == 'en'
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                  style: TextStyle(
                      fontSize: fontSize,
                      fontFamily: AppFonts.getPrimaryFont(context)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
