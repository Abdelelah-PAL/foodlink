import 'package:flutter/material.dart';
import 'package:foodlink/controllers/meal_controller.dart';
import '../../../core/constants/assets.dart';
import '../../../core/utils/size_config.dart';
import '../../../providers/settings_provider.dart';

class NameRow extends StatelessWidget {
  const NameRow(
      {super.key,
      required this.name,
      required this.fontSize,
      required this.textWidth,
      required this.settingsProvider,
      required this.height,
      required this.maxLines});

  final String name;
  final double fontSize;
  final double textWidth;
  final SettingsProvider settingsProvider;
  final double height;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    String writtenLanguage = MealController().detectLanguage(name);
    return SizeConfig.customSizedBox(
      null,
      height,
      Row(
        textDirection:
            writtenLanguage == 'en' ? TextDirection.ltr : TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(Assets.mealNameIcon),
          SizeConfig.customSizedBox(10, null, null),
          SizeConfig.customSizedBox(
            textWidth,
            null,
            Text(
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              name,
              textAlign:
                  writtenLanguage == 'en' ? TextAlign.left : TextAlign.right,
              textDirection: writtenLanguage == 'en'
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  fontFamily:
                      writtenLanguage == 'en' ? 'salsa' : 'MyriadArabic'),
            ),
          ),
        ],
      ),
    );
  }
}
