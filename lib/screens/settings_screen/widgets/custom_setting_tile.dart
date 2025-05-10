import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/size_config.dart';
import '../../../providers/settings_provider.dart';
import '../../widgets/custom_text.dart';

class CustomSettingTile extends StatelessWidget {
  const CustomSettingTile(
      {super.key, required this.icon, required this.text, this.trailing, required this.givenWrittenLanguage, this.onTap});

  final String icon;
  final String text;
  final Widget? trailing;
  final String givenWrittenLanguage;
  final VoidCallback? onTap;


  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider =
        Provider.of<SettingsProvider>(context, listen: true);
    return Container(
        height: SizeConfig.getProportionalHeight(27),
        margin: EdgeInsets.symmetric(
          vertical: SizeConfig.getProportionalHeight(7),
        ),
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.getProportionalWidth(10)),
        child: GestureDetector(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: settingsProvider.language == "en"
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            textDirection: settingsProvider.language == "en"
                ? TextDirection.ltr
                : TextDirection.rtl,
            children: [
              SizeConfig.customSizedBox(34, 24, Image.asset(icon)),
              Expanded(
                child: CustomText(
                  text: text,
                  isCenter: false,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  givenWrittenLanguage: givenWrittenLanguage,
                ),
              ),
              if (trailing != null) trailing!
            ],
          ),
        ));
  }
}
