import 'package:flutter/material.dart';
import 'package:foodlink/services/translation_services.dart';
import 'package:provider/provider.dart';
import '../../core/constants/fonts.dart';
import '../../providers/settings_provider.dart';

class CustomText extends StatelessWidget {
  const CustomText({super.key, required this.isCenter, required this.text, required this.fontSize, required this.fontWeight});
  final bool isCenter;
  final String text;
  final double fontSize;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider =
    Provider.of<SettingsProvider>(context, listen: true);
    return Text(
      textAlign: isCenter ? TextAlign.center : settingsProvider.language == 'en' ? TextAlign.left : TextAlign.right,
      TranslationService().translate(text),
      textDirection:  settingsProvider.language == 'en' ? TextDirection.ltr : TextDirection.rtl,
      style: TextStyle(
        fontFamily: AppFonts.primaryFont,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
