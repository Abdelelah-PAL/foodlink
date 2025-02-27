import 'package:flutter/material.dart';
import 'package:foodlink/core/constants/colors.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/services/translation_services.dart';

import '../../../core/constants/fonts.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.onTap , required this.text, required this.width, required this.height});

  final VoidCallback? onTap;
  final String text;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: SizeConfig.getProportionalHeight(height),
        width: SizeConfig.getProportionalWidth(width),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: AppColors.widgetsColor),
        child: Center(
          child: Text(
            TranslationService().translate(text),
            style:  TextStyle(
                fontWeight: FontWeight.bold, // Semi-bold weight
                fontSize: 25,
                fontFamily: AppFonts.getPrimaryFont(context),
                color: AppColors.fontColor),
          ),
        ),
      ),
    );
  }
}
