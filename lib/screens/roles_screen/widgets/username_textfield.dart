import 'package:flutter/material.dart';
import 'package:foodlink/controllers/dashboard_controller.dart';
import 'package:foodlink/core/constants/colors.dart';
import 'package:foodlink/core/utils/size_config.dart';

import '../../../core/constants/fonts.dart';

class UsernameTextField extends StatelessWidget {
  const UsernameTextField({super.key, required this.hintText,  required this.controller});

  final String hintText;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.getProportionalWidth(152),
      height: SizeConfig.getProportionalHeight(42),
      padding: EdgeInsets.only(bottom: SizeConfig.getProportionalHeight(13)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(width: 1.0, color: AppColors.widgetsColor),
      ),
      child: TextField(
        controller: controller!,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 12,
              color: AppColors.hintTextColor,
              fontFamily: AppFonts.primaryFont),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
