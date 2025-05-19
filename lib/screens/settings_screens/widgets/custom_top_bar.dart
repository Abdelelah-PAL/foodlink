import 'package:flutter/material.dart';
import '../../../core/utils/size_config.dart';
import '../../../providers/settings_provider.dart';
import '../../widgets/custom_back_button.dart';
import '../../widgets/custom_text.dart';

class CustomTopBar extends StatelessWidget {
  const CustomTopBar(
      {super.key,
      required this.text,
      required this.rightPadding,
      required this.settingsProvider});

  final String text;
  final double rightPadding;
  final SettingsProvider settingsProvider;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: SizeConfig.getProportionalWidth(50),
        right: SizeConfig.getProportionalWidth(rightPadding),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CustomBackButton(),
          Center(
            child: CustomText(
                isCenter: true,
                text: text,
                fontSize: settingsProvider.language == "en" ? 18 : 30,
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
