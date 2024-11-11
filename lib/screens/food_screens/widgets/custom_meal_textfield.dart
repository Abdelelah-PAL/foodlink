import 'package:flutter/material.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/providers/general_provider.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/fonts.dart';

class CustomMealTextField extends StatelessWidget {
  const CustomMealTextField(
      {super.key,
      required this.width,
      required this.height,
      required this.hintText,
      required this.icon,
      required this.controller,
        required this.maxLines});

  final double width;
  final double height;
  final String hintText;
  final String icon;
  final TextEditingController controller;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.symmetric(vertical: SizeConfig.getProportionalHeight(10)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(width: 1.0, color: AppColors.widgetsColor),
      ),
      child: TextField(
        maxLines: maxLines,
        controller: controller,
        textAlign: GeneralProvider().language == 'en'
            ? TextAlign.left
            : TextAlign.right,
        decoration: InputDecoration(
          prefixIcon:
              GeneralProvider().language == 'en' ? Image.asset(icon) : null,
          suffixIcon:
              GeneralProvider().language == 'en' ? null : Image.asset(icon),
          hintText: hintText,
          hintStyle: TextStyle(
              fontSize: 20,
              color: AppColors.hintTextColor,
              fontFamily: AppFonts.primaryFont),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
