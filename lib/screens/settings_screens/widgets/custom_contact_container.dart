import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/size_config.dart';
import '../../../providers/settings_provider.dart';
import '../../widgets/custom_text.dart';

class CustomContactContainer extends StatelessWidget {
  const CustomContactContainer(
      {super.key,
      required this.settingsProvider,
      required this.text,
      required this.icon,
      this.onTap,
      required this.underlinedText});

  final SettingsProvider settingsProvider;
  final String text;
  final String icon;
  final VoidCallback? onTap;
  final bool underlinedText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.getProportionalHeight(286),
      height: SizeConfig.getProportionalHeight(53),
      margin:
          EdgeInsets.symmetric(vertical: SizeConfig.getProportionalHeight(22)),
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.getProportionalWidth(10),
          vertical: SizeConfig.getProportionalHeight(2)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppColors.widgetsColor,
          width: 3.0, // Border width
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onTap,
            child: CustomText(
              isCenter: false,
              text: text,
              fontSize: settingsProvider.language == "en" ? 16 : 20,
              fontWeight: FontWeight.normal,
              underlined: underlinedText,
            ),
          ),
          Image.asset(icon)
        ],
      ),
    );
  }
}
