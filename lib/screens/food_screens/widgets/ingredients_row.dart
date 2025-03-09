import 'package:flutter/material.dart';
import '../../../controllers/general_controller.dart';
import '../../../core/constants/assets.dart';
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
      required this.height});

  final Meal meal;
  final double fontSize;
  final double textWidth;
  final int maxLines;
  final SettingsProvider settingsProvider;
  final double height;

  @override
  Widget build(BuildContext context) {
    String writtenLanguage = GeneralController().detectLanguage(meal.recipe!);
    return SizeConfig.customSizedBox(
      null,
      height,
      Row(
        textDirection: settingsProvider.language == 'en'
            ? TextDirection.ltr
            : TextDirection.rtl,
        mainAxisAlignment: settingsProvider.language == 'en'
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(Assets.mealIngredients),
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
                  textAlign: writtenLanguage == 'en' ? TextAlign.end : TextAlign.start,
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
