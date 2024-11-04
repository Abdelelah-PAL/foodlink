import 'package:flutter/material.dart';
import 'package:foodlink/core/constants/colors.dart';
import 'package:foodlink/core/constants/fonts.dart';

import '../../../core/utils/size_config.dart';
import '../../../providers/general_provider.dart';

class CustomErrorTxt extends StatelessWidget {
  const CustomErrorTxt({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: GeneralProvider().language == 'en'
          ? Alignment.topLeft
          : Alignment.topRight,
      child: Padding(
        padding: GeneralProvider().language == 'en'
            ? EdgeInsets.only(left: SizeConfig.getProportionalWidth(35))
            : EdgeInsets.only(right: SizeConfig.getProportionalWidth(35)),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontFamily: AppFonts.primaryFont,
            color: AppColors.errorColor,
          ),
        ),
      ),
    );
  }
}
