import 'package:flutter/material.dart';
import 'package:foodlink/screens/widgets/custom_text.dart';

import '../../../core/utils/size_config.dart';

class HealthyIconText extends StatelessWidget {
  const HealthyIconText({super.key, required this.icon, required this.text});

  final String icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(icon),
        SizeConfig.customSizedBox(null, 10, null),
        CustomText(
            isCenter: true,
            text: text,
            fontSize: 20,
            fontWeight: FontWeight.bold)
      ],
    );
  }
}
