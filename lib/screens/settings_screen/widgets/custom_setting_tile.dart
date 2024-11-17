import 'package:flutter/material.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/providers/general_provider.dart';
import 'package:foodlink/screens/widgets/custom_text.dart';

class CustomSettingTile extends StatelessWidget {
  const CustomSettingTile(
      {super.key, required this.icon, required this.text, this.trailing});

  final String icon;
  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.getProportionalHeight(25),
      margin:
          EdgeInsets.symmetric(vertical: SizeConfig.getProportionalHeight(5)),
      child: ListTile(
        leading: GeneralProvider().language == 'en'
            ? SizeConfig.customSizedBox(24, 24, Image.asset(icon))
            : trailing,
        title: CustomText(
          text: text,
          isCenter: false,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        trailing: GeneralProvider().language == 'en'
            ? trailing
            : SizeConfig.customSizedBox(24, 24, Image.asset(icon)),
      ),
    );
  }
}
