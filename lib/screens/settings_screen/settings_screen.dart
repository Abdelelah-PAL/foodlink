import 'package:flutter/material.dart';
import 'package:foodlink/core/constants/colors.dart';
import 'package:foodlink/providers/settings_provider.dart';
import 'package:foodlink/providers/users_provider.dart';
import 'package:foodlink/screens/settings_screen/widgets/custom_setting_tile.dart';
import 'package:foodlink/screens/settings_screen/widgets/custom_settings_container.dart';
import 'package:foodlink/screens/widgets/custom_text.dart';
import 'package:foodlink/screens/widgets/profile_circle.dart';
import 'package:provider/provider.dart';
import '../../core/constants/assets.dart';
import '../../core/utils/size_config.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    UsersProvider usersProvider =
        Provider.of<UsersProvider>(context, listen: true);
    SettingsProvider settingsProvider =
        Provider.of<SettingsProvider>(context, listen: true);
    var userId = usersProvider.selectedUser!.userId;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizeConfig.customSizedBox(null, 50, null),
        const CustomText(
            isCenter: true,
            text: "settings",
            fontSize: 30,
            fontWeight: FontWeight.bold),
        SizeConfig.customSizedBox(null, 25, null),
        const ProfileCircle(
          height: 68,
          width: 68,
          iconSize: 50,
        ),
        SizeConfig.customSizedBox(null, 50, null),
        CustomSettingsContainer(height: 125, children: [
          CustomSettingTile(icon: Assets.editInfo, text: "edit_data"),
          CustomSettingTile(icon: Assets.privacy, text: "privacy"),
          CustomSettingTile(
              icon: Assets.language,
              text: "language",
              trailing: GestureDetector(
                onTap: ()  {
                  var language = settingsProvider.settings.language == "en" ? "ar" : "en";
                  setState(() {
                    settingsProvider.settings.language = language;
                    settingsProvider.changeLanguage(language, userId);
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  height: SizeConfig.getProportionalHeight(22),
                  width: SizeConfig.getProportionalWidth(65),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.languageContainerColor,
                      border:
                          Border.all(width: 1, color: AppColors.widgetsColor)),
                  child: Text(settingsProvider.settings.language == "en"
                      ? "English"
                      : "العربية"),
                ),
              )),
        ]),
        CustomSettingsContainer(height: 103, children: [
          CustomSettingTile(
            icon: Assets.notifications,
            text: "notifications",
            trailing: Switch(
              thumbColor: WidgetStateProperty.all(
                  settingsProvider.activeNotification == true
                      ? AppColors.widgetsColor
                      : AppColors.inActiveThumbColor),
              activeTrackColor: AppColors.fontColor,
              value: settingsProvider.activeNotification,
              onChanged: (value) {
                setState(() {
                  settingsProvider.settings.activeNotifications = value;
                });
                settingsProvider.toggleNotifications(userId);
              },
            ),
          ),
          CustomSettingTile(
            icon: Assets.updates,
            text: "updates",
            trailing: Switch(
              thumbColor: WidgetStateProperty.all(
                  settingsProvider.activeUpdates == true
                      ? AppColors.widgetsColor
                      : AppColors.inActiveThumbColor),
              activeTrackColor: AppColors.fontColor,
              value: settingsProvider.activeUpdates,
              onChanged: (value) {
                setState(() {
                  settingsProvider.activeUpdates = value;
                });
                settingsProvider.toggleUpdates(userId);
              },
            ),
          ),
        ]),
        CustomSettingsContainer(height: 103, children: [
          CustomSettingTile(icon: Assets.contactUs, text: "contact_us"),
          CustomSettingTile(icon: Assets.support, text: "help_support")
        ])
      ],
    );
  }
}
