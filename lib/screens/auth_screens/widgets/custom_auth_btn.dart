import 'package:flutter/material.dart';
import 'package:foodlink/core/constants/colors.dart';
import 'package:foodlink/core/utils/size_config.dart';
import '../../../core/constants/fonts.dart';

class CustomAuthBtn extends StatelessWidget {
  const CustomAuthBtn({super.key, required this.onTap, required this.text});

  final VoidCallback? onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: SizeConfig.getProportionalHeight(48),
        width: SizeConfig.getProportionalWidth(312),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: AppColors.primaryColor),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontWeight: FontWeight.w600, // Semi-bold weight
                fontSize: 16,
                fontFamily: AppFonts.getPrimaryFont(context),
                color: AppColors.backgroundColor),
          ),
        ),
      ),
    );
  }
}
