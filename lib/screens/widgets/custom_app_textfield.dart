import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';
import '../../core/utils/size_config.dart';
import '../../providers/settings_provider.dart';
import '../../services/translation_services.dart';

class CustomAppTextField extends StatelessWidget {
  const CustomAppTextField(
      {super.key,
      required this.width,
      required this.height,
      this.hintText,
      required this.controller,
      required this.maxLines,
      required this.settingsProvider,
      this.onTap,
      required this.enabled,
      required this.isCentered});

  final double width;
  final double height;
  final String? hintText;
  final TextEditingController controller;
  final int maxLines;
  final SettingsProvider settingsProvider;
  final VoidCallback? onTap;
  final bool enabled;
  final bool isCentered;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () {
            return;
          },
      child: Container(
        width: SizeConfig.getProportionalWidth(width),
        height: SizeConfig.getProportionalHeight(height),
        margin: EdgeInsets.only(
            bottom: SizeConfig.getProportionalHeight(20)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(width: 3.0, color: AppColors.widgetsColor),
        ),
        child: TextField(
          enabled: enabled,
          maxLines: maxLines,
          controller: controller,
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(
            color: AppColors.fontColor,  // <-- Add this line to make text black
            fontFamily: AppFonts.getPrimaryFont(context),
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
          textAlign: isCentered
              ? TextAlign.center
              : settingsProvider.language == 'en'
                  ? TextAlign.left
                  : TextAlign.right,
          decoration: InputDecoration(
            hintText: hintText != null
                ? TranslationService().translate(hintText!)
                : null,
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
    );
  }
}
