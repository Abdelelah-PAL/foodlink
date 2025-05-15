import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/size_config.dart';
import '../../../providers/settings_provider.dart';
import '../../widgets/custom_text.dart';

class CustomAccountInfoTile extends StatelessWidget {
  const CustomAccountInfoTile(
      {super.key, required this.text, required this.controller});

  final String text;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider =
        Provider.of<SettingsProvider>(context, listen: true);
    return Container(
        height: SizeConfig.getProportionalHeight(53),
        width: SizeConfig.getProportionalHeight(342),
        margin: EdgeInsets.symmetric(
          vertical: SizeConfig.getProportionalHeight(7),
        ),
        padding: EdgeInsets.only(
            bottom: SizeConfig.getProportionalHeight(10),
            left: SizeConfig.getProportionalWidth(10),
            right: SizeConfig.getProportionalWidth(10)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(width: 3.0, color: AppColors.widgetsColor),
        ),
        child: Column(
          mainAxisAlignment: settingsProvider.language == "en"
              ? MainAxisAlignment.start
              : MainAxisAlignment.end,
          textDirection: settingsProvider.language == "en"
              ? TextDirection.ltr
              : TextDirection.rtl,
          children: [
            Align(
              alignment: settingsProvider.language == 'en'
                  ? Alignment.topLeft
                  : Alignment.topRight,
              child: CustomText(
                text: text,
                isCenter: false,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Expanded(
              child: Align(
                alignment: settingsProvider.language == 'en'
                    ? Alignment.bottomRight
                    : Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: SizeConfig.getProportionalHeight(10),
                  ),
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    textAlign: settingsProvider.language == 'en'
                        ? TextAlign.right
                        : TextAlign.left,
                    maxLines: 1,
                    style: const TextStyle(overflow: TextOverflow.ellipsis),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
