import 'package:flutter/material.dart';
import 'package:foodlink/controllers/general_controller.dart';
import '../../core/constants/fonts.dart';
import '../../services/translation_services.dart';

class CustomText extends StatelessWidget {
  const CustomText({super.key, required this.isCenter, required this.text, required this.fontSize, required this.fontWeight, this.color, this.maxLines});
  final bool isCenter;
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final int? maxLines;


  @override
  Widget build(BuildContext context) {
    String writtenLanguage = GeneralController().detectLanguage(text);
    return Text(
      textAlign: isCenter ? TextAlign.center : writtenLanguage == 'en' ? TextAlign.left : TextAlign.right,
      TranslationService().translate(text),
      textDirection:  writtenLanguage == 'en' ? TextDirection.ltr : TextDirection.rtl,
      maxLines: maxLines ?? 1,
      style: TextStyle(
        fontFamily: AppFonts.getPrimaryFont(context),
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
