import 'package:flutter/material.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/providers/general_provider.dart';

import '../../../core/constants/colors.dart';

class CustomSettingsContainer extends StatelessWidget {
  const CustomSettingsContainer(
      {super.key, required this.height, required this.children});

  final double height;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: SizeConfig.getProportionalWidth(346),
        height: SizeConfig.getProportionalHeight(height),
        margin: EdgeInsets.symmetric(
            vertical: SizeConfig.getProportionalHeight(10),
            horizontal: SizeConfig.getProportionalWidth(20)),
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.getProportionalHeight(10),
            ),
        decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(blurRadius: 2),
            ]),
        child: Column(
          crossAxisAlignment: GeneralProvider().language == "en"
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: children,
        ),
      ),
    );
  }
}
