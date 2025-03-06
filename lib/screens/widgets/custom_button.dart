import 'package:flutter/material.dart';
import 'package:foodlink/controllers/general_controller.dart';
import '../../../core/constants/fonts.dart';
import '../../core/constants/colors.dart';
import '../../core/utils/size_config.dart';
import '../../services/translation_services.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.width,
    required this.height,
    required this.isDisabled,
    this.fontSize,
  });

  final VoidCallback? onTap;
  final String text;
  final double width;
  final double height;
  final bool isDisabled;
  final double? fontSize;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    String writtenLanguage = GeneralController().detectLanguage(widget.text);
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
            textAlign: TextAlign.center,
            TranslationService().translate(widget.text),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: widget.fontSize ?? ( writtenLanguage == 'en' ? 18 : 25),
              fontFamily: AppFonts.getPrimaryFont(context),
              color: AppColors.fontColor,
            ),
          ),
        ),
      ),
    );
  }
}
