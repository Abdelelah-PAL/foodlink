import 'package:flutter/material.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/providers/general_provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../models/onboarding_content.dart';

class OnBoardingBody extends StatelessWidget {
  const OnBoardingBody({
    super.key,
    required this.content,
  });

  final OnBoardingContent content;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizeConfig.customSizedBox(null, 120, null),
        SizeConfig.customSizedBox(316, 316, Image.asset(content.imageURL)),
        SizeConfig.customSizedBox(null, 100, null),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SizeConfig.customSizedBox(
            null,
            110,
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                    text: content.firstTextSpan,
                    style: TextStyle(
                        fontSize: GeneralProvider().language == 'en' ? 30 : 45,
                        color: AppColors.fontColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.primaryFont),
                  ),
                  TextSpan(
                    text: content.secondTextSpan,
                    style: TextStyle(
                        fontSize: GeneralProvider().language == 'en' ? 30 : 45,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.primaryFont),
                  ),
                  content.thirdTextSpan == null
                      ? const TextSpan(
                          text: '',
                        )
                      : TextSpan(
                          text: content.thirdTextSpan,
                          style: TextStyle(
                              fontSize:
                                  GeneralProvider().language == 'en' ? 30 : 45,
                              color: AppColors.fontColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: AppFonts.primaryFont),
                        )
                ])),
          ),
        ),
      ],
    );
  }
}
