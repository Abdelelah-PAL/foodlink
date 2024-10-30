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
        SizedBox(
          height: SizeConfig.getProportionalHeight(120),
        ),
        SizedBox(
            width: SizeConfig.getProportionalWidth(316),
            height: SizeConfig.getProportionalHeight(316),
            child: Image.asset(content.imageURL)),
        SizedBox(
          height: SizeConfig.getProportionalHeight(100),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: RichText(
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
                      fontSize: GeneralProvider().language == 'en' ? 30 : 45,
                      color: AppColors.fontColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFonts.primaryFont),
                )
              ])),
        ),
      ],
    );
  }
}
