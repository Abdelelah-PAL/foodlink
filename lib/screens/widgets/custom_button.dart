import 'package:flutter/material.dart';
import 'package:foodlink/core/constants/colors.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/services/translation_services.dart';

import '../../../core/constants/fonts.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.width,
    required this.height,
    required this.isDisabled,
  });

  final VoidCallback? onTap;
  final String text;
  final double width;
  final double height;
  final bool isDisabled;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: SizeConfig.getProportionalHeight(widget.height),
        width: SizeConfig.getProportionalWidth(widget.width),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.widgetsColor, // Change color when disabled
        ),
        child: Center(
          child: Text(
            TranslationService().translate(widget.text),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              fontFamily: AppFonts.getPrimaryFont(context),
              color: AppColors.fontColor,
            ),
          ),
        ),
      ),
    );
  }
}
