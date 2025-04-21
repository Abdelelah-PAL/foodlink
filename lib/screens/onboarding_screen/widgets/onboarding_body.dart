import 'package:flutter/material.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../models/onboarding_content.dart';
import '../../../providers/settings_provider.dart';

class OnBoardingBody extends StatelessWidget {
  const OnBoardingBody({
    super.key,
    required this.content,
  });

  final OnBoardingContent content;

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    return Column(
      children: [
        SizeConfig.customSizedBox(null, 120, null),
        SizeConfig.customSizedBox(316, 316, Image.asset(content.imageURL)),
        SizeConfig.customSizedBox(null, 100, null),
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: SizeConfig.getProportionalWidth(20)),
          child: SizeConfig.customSizedBox(
            null,
            110,
            RichText(
                textAlign: TextAlign.center,
                textDirection: settingsProvider.language == "en" ? TextDirection.ltr : TextDirection.rtl,
                text: TextSpan(children: [
                  TextSpan(
                    text: content.firstTextSpan,
                    style: TextStyle(
                        fontSize: SettingsProvider().language == 'en' ? 30 : 45,
                        color: AppColors.fontColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.getPrimaryFont(context)),
                  ),
                  TextSpan(
                    text: content.secondTextSpan,
                    style: TextStyle(
                        fontSize: SettingsProvider().language == 'en' ? 30 : 45,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.getPrimaryFont(context)),
                  ),
                  content.thirdTextSpan == null
                      ? const TextSpan(
                          text: '',
                        )
                      : TextSpan(
                          text: content.thirdTextSpan,
                          style: TextStyle(
                              fontSize:
                                  SettingsProvider().language == 'en' ? 30 : 45,
                              color: AppColors.fontColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: AppFonts.getPrimaryFont(context)),
                        )
                ])),
          ),
        ),
      ],
    );
  }
}
