import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../core/utils/size_config.dart';
import '../../../providers/general_provider.dart';
import '../../../services/translation_services.dart';

class CustomAuthFooter extends StatelessWidget {
  const CustomAuthFooter({
    super.key,
    required this.headingText,
    required this.tailText,
    required this.onTap,
  });

  final String headingText;
  final String tailText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: GeneralProvider().language == "en"
          ? TextDirection.ltr
          : TextDirection.rtl,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: TranslationService().translate(headingText),
              style: TextStyle(
                fontFamily: AppFonts.primaryFont,
                fontSize: 16,
                color: AppColors.fontColor,
              ),
            ),
            WidgetSpan(
              child: SizeConfig.customSizedBox(4, null, null),
            ),
            TextSpan(
              text: TranslationService().translate(tailText),
              style: TextStyle(
                fontFamily: AppFonts.primaryFont,
                fontSize: 16,
                color: AppColors.primaryColor,
                decoration: TextDecoration.underline,
                decorationColor:
                    AppColors.primaryColor, // Change the underline color here
              ),
              recognizer: TapGestureRecognizer()..onTap = onTap,
            ),
          ],
        ),
        textAlign: TextAlign.start,
      ),
    );
  }
}
