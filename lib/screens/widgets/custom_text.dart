import 'package:flutter/material.dart';
import 'package:foodlink/providers/general_provider.dart';
import 'package:foodlink/services/translation_services.dart';
import '../../core/constants/fonts.dart';

class CustomText extends StatelessWidget {
  const CustomText({super.key, required this.isCenter, required this.text, required this.fontSize, required this.fontWeight});
  final bool isCenter;
  final String text;
  final double fontSize;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      textAlign: isCenter ? TextAlign.center : GeneralProvider().language == 'en' ? TextAlign.left : TextAlign.right,
      TranslationService().translate(text),
      textDirection:  GeneralProvider().language == 'en' ? TextDirection.ltr : TextDirection.rtl,
      style: TextStyle(
        fontFamily: AppFonts.primaryFont,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
