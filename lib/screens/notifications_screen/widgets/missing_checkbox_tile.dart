import 'package:flutter/material.dart';
import '../../../controllers/general_controller.dart';
import '../../../core/utils/size_config.dart';
import '../../../models/notification.dart';
import '../../../providers/settings_provider.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/disabled_xchecbox.dart';

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
    String writtenLanguage = GeneralController()
        .detectLanguage(notification.missingIngredients[index]);
    return Padding(
        padding: EdgeInsets.only(
            top: SizeConfig.getProportionalHeight(10),
            right: SizeConfig.getProportionalWidth(20),
            left: SizeConfig.getProportionalWidth(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          textDirection: settingsProvider.language == 'en'
              ? TextDirection.rtl
              : TextDirection.ltr,
          children: [
            CustomText(
                isCenter: false,
                text: notification.missingIngredients[index],
                fontSize: writtenLanguage == 'en' ? 12 : 14,
                fontWeight: FontWeight.normal),
            SizeConfig.customSizedBox(10, null, null),
           const DisabledXCheckbox()
          ],
        ));
  }
}
