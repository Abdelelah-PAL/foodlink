import 'package:flutter/material.dart';
import 'package:foodlink/core/constants/colors.dart';
import '../../../core/utils/size_config.dart';



class Dot extends StatelessWidget {
  const Dot({super.key, required this.isSelected});
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  EdgeInsets.symmetric(horizontal: SizeConfig.getProportionalWidth(15)),
      width: SizeConfig.getProportionalWidth(12),
      height: SizeConfig.getProportionalHeight(12),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
         color: isSelected ? AppColors.primaryColor : Colors.black,
      ),

    );
  }
}
