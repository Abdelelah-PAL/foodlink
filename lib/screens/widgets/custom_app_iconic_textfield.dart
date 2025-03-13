import 'package:flutter/material.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/screens/widgets/custom_text.dart';
import 'package:foodlink/services/translation_services.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';
import '../../providers/settings_provider.dart';

class CustomAppIconicTextField extends StatelessWidget {
  const CustomAppIconicTextField(
      {super.key,
      required this.width,
      required this.height,
      required this.headerText,
      required this.icon,
      required this.controller,
      required this.maxLines,
      required this.iconSizeFactor,
      required this.iconPadding,
      required this.settingsProvider,
      required this.enabled});

  final double width;
  final double height;
  final String headerText;
  final String icon;
  final TextEditingController controller;
  final int maxLines;
  final double iconSizeFactor;
  final double iconPadding;
  final SettingsProvider settingsProvider;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: EdgeInsets.only(
            right: SizeConfig.getProportionalWidth(iconPadding)),
        child: Row(
          textDirection: settingsProvider.language == 'en'
              ? TextDirection.ltr
              : TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizeConfig.customSizedBox(
                iconSizeFactor, iconSizeFactor, Image.asset(icon)),
            SizeConfig.customSizedBox(10, null, null),
            CustomText(
              isCenter: false,
              text: TranslationService().translate(headerText),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
      Container(
        width: SizeConfig.getProportionalWidth(width),
        height: SizeConfig.getProportionalHeight(height),
        margin: EdgeInsets.symmetric(
            vertical: SizeConfig.getProportionalHeight(10),
            horizontal: SizeConfig.getProportionalWidth(26)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(width: 1.0, color: AppColors.widgetsColor),
        ),
        child: TextField(
          enabled: enabled,
          maxLines: maxLines,
          controller: controller,
          textAlign: settingsProvider.language == 'en'
              ? TextAlign.left
              : TextAlign.right,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(
                SizeConfig.getProportionalWidth(10),
                SizeConfig.getProportionalHeight(2),
                SizeConfig.getProportionalWidth(10),
                SizeConfig.getProportionalHeight(2)),
            hintStyle: TextStyle(
                fontSize: 20,
                color: AppColors.hintTextColor,
                fontFamily: AppFonts.getPrimaryFont(context)),
            border: InputBorder.none,
          ),
        ),
      ),
    ]);
  }
}
