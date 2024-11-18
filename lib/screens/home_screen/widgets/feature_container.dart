import 'package:flutter/material.dart';
import 'package:foodlink/core/constants/fonts.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/size_config.dart';
import '../../../providers/settings_provider.dart';

class FeatureContainer extends StatelessWidget {
  const FeatureContainer(
      {super.key, required this.imageUrl, required this.text, required this.settingsProvider});

  final String imageUrl;
  final String text;
  final SettingsProvider settingsProvider;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: SizeConfig.getProportionalHeight(15)),
      child: Stack(
        alignment: Alignment.center, // Center everything within the Stack
        children: [
          Container(
            width: SizeConfig.getProportionalWidth(332),
            height: SizeConfig.getProportionalHeight(127),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
            child: Image.asset(imageUrl, fit: BoxFit.fill),
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: settingsProvider.language == "en" ? 25 : 45,
              fontFamily: AppFonts.primaryFont,
              fontWeight: FontWeight.bold,
              shadows: const <Shadow>[
                Shadow(
                  offset: Offset(0.5, 0.5),
                  blurRadius: 8.0,
                  color: AppColors.primaryColor,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
