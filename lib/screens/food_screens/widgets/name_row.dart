import 'package:flutter/material.dart';
import '../../../controllers/general_controller.dart';
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
    String writtenLanguage = GeneralController().detectLanguage(name);
    return FittedBox(
      child: Row(
        textDirection: settingsProvider.language == 'en'
            ? TextDirection.ltr
            : TextDirection.rtl,
        mainAxisAlignment: settingsProvider.language == 'en'
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: [
          Image.asset(Assets.mealNameIcon),
          SizeConfig.customSizedBox(
            textWidth,
            null,
            Text(
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              name,
              textAlign: writtenLanguage == 'en' ? TextAlign.end : TextAlign.start,
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
