import 'package:flutter/material.dart';
import 'package:foodlink/core/utils/size_config.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../providers/settings_provider.dart';

class CustomMealTextField extends StatelessWidget {
  const CustomMealTextField(
      {super.key,
      required this.width,
      required this.height,
      required this.hintText,
      required this.icon,
      required this.controller,
      required this.maxLines,
      required this.iconSizeFactor,
      required this.hintTopPadding,
      required this.horizontalPosition,
      required this.settingsProvider});

  final double width;
  final double height;
  final String hintText;
  final String icon;
  final TextEditingController controller;
  final int maxLines;
  final double iconSizeFactor;
  final double hintTopPadding;
  final double horizontalPosition;
  final SettingsProvider settingsProvider;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        width: width,
        height: height,
        margin: EdgeInsets.symmetric(
            vertical: SizeConfig.getProportionalHeight(10)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(width: 1.0, color: AppColors.widgetsColor),
        ),
        child: TextField(
          maxLines: maxLines,
          controller: controller,
          textAlign: settingsProvider.language == 'en'
              ? TextAlign.left
              : TextAlign.right,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(
                SizeConfig.getProportionalWidth(40),
                SizeConfig.getProportionalHeight(hintTopPadding),
                SizeConfig.getProportionalWidth(40),
                SizeConfig.getProportionalHeight(2)),
            hintText: hintText,
            hintStyle: TextStyle(
                fontSize: 20,
                color: AppColors.hintTextColor,
                fontFamily: AppFonts.primaryFont),
            border: InputBorder.none,
          ),
        ),
      ),
      Positioned(
          left: settingsProvider.language == 'en'
              ? SizeConfig.getProportionalHeight(horizontalPosition)
              : null,
          right: settingsProvider.language == 'en'
              ? null
              : SizeConfig.getProportionalHeight(horizontalPosition),
          top: SizeConfig.getProportionalHeight(15),
          child: SizeConfig.customSizedBox(
              iconSizeFactor, iconSizeFactor, Image.asset(icon))),
    ]);
  }
}
