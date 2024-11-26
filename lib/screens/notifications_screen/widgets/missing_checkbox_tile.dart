import 'package:flutter/material.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/providers/settings_provider.dart';
import '../../../core/constants/colors.dart';
import '../../../models/notification.dart';
import '../../widgets/custom_text.dart';

class MissingCheckboxTile extends StatelessWidget {
  const MissingCheckboxTile({
    super.key,
    required this.settingsProvider,
    required this.notification,
    required this.index,
  });

  final SettingsProvider settingsProvider;
  final Notifications notification;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
            top: 0,
            right: SizeConfig.getProportionalWidth(20),
            left: SizeConfig.getProportionalWidth(20)),
        child: settingsProvider.language == 'en'
            ? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomText(
                      isCenter: false,
                      text: notification.missingIngredients[index],
                      fontSize: 20,
                      fontWeight: FontWeight.normal),
                  const Checkbox(
                    value: true,
                    onChanged: null,
                  )
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomText(
                      isCenter: false,
                      text: notification.missingIngredients[index],
                      fontSize: 20,
                      fontWeight: FontWeight.normal),
                  const Checkbox(
                    activeColor: AppColors.primaryColor,
                    checkColor: AppColors.backgroundColor,
                    value: true,
                    onChanged: null,
                  )
                ],
              ));
  }
}
