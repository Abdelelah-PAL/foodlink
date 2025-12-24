import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../controllers/authentication_controller.dart';
import '../../core/constants/assets.dart';
import '../../core/constants/colors.dart';
import '../../core/utils/size_config.dart';
import '../../providers/authentication_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/users_provider.dart';
import '../widgets/custom_text.dart';
import 'contact_us_screen.dart';
import 'edit_account_info_screen.dart';
import 'privacy_screen.dart';
import 'widgets/custom_setting_tile.dart';
import 'widgets/custom_settings_container.dart';
import 'widgets/profile_picture_container.dart';

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
    DashboardProvider dashboardProvider =
        Provider.of<DashboardProvider>(context, listen: true);
    AuthenticationProvider authenticationProvider =
        Provider.of<AuthenticationProvider>(context, listen: true);
    var userId = usersProvider.selectedUser!.userId;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizeConfig.customSizedBox(null, 50, null),
          CustomText(
            isCenter: true,
            text: "settings",
            fontSize: 30,
            fontWeight: FontWeight.bold,
            givenWrittenLanguage: settingsProvider.language,
          ),
          SizeConfig.customSizedBox(null, 25, null),
          ProfilePictureContainer(
            settingsProvider: settingsProvider,
            usersProvider: usersProvider,
            circleSize: 68,
            iconSize: 50,
          ),
          SizeConfig.customSizedBox(null, 50, null),
          CustomSettingsContainer(
              height: 125,
              settingsProvider: settingsProvider,
              children: [
                CustomSettingTile(
                  icon: Assets.editInfo,
                  text: "edit_data",
                  onTap: () {
                    usersProvider.usernameController.text =
                        usersProvider.selectedUser!.username!;
                    usersProvider.emailController.text =
                        usersProvider.selectedUser!.email;
                    Get.to(EditAccountInfoScreen(
                        usersProvider: usersProvider,
                        settingsProvider: settingsProvider));
                  },
                  givenWrittenLanguage: settingsProvider.language,
                ),
                CustomSettingTile(
                    icon: Assets.privacy,
                    text: "privacy",
                    onTap: () => Get.to(
                        PrivacyScreen(settingsProvider: settingsProvider)),
                    givenWrittenLanguage: settingsProvider.language),
                CustomSettingTile(
                    icon: Assets.language,
                    text: "language",
                    givenWrittenLanguage: settingsProvider.language,
                    trailing: GestureDetector(
                      onTap: () {
                        var language =
                            settingsProvider.language == "en" ? "ar" : "en";
                        settingsProvider.changeLanguage(
                            language, userId, context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: SizeConfig.getProportionalHeight(22),
                        width: SizeConfig.getProportionalWidth(65),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.languageContainerColor,
                            border: Border.all(
                                width: 1, color: AppColors.widgetsColor)),
                        child: Text(settingsProvider.language == "en"
                            ? "العربية"
                            : "English"),
                      ),
                    )),
              ]),
          CustomSettingsContainer(
              height: SizeConfig.getProportionalHeight(100),
              settingsProvider: settingsProvider,
              children: [
                CustomSettingTile(
                  icon: Assets.notifications,
                  text: "notifications",
                  givenWrittenLanguage: settingsProvider.language,
                  trailing: Transform.scale(
                    scale: .7,
                    child: Switch(
                      thumbColor: WidgetStateProperty.all(
                          settingsProvider.settings.activeNotifications == true
                              ? AppColors.widgetsColor
                              : AppColors.inActiveThumbColor),
                      activeTrackColor: AppColors.fontColor,
                      value: settingsProvider.settings.activeNotifications,
                      onChanged: (value) {
                        settingsProvider.toggleNotifications(userId);
                      },
                    ),
                  ),
                ),
                CustomSettingTile(
                  icon: Assets.updates,
                  text: "updates",
                  givenWrittenLanguage: settingsProvider.language,
                  trailing: Transform.scale(
                    scale: .7,
                    child: Switch(
                      thumbColor: WidgetStateProperty.all(
                          settingsProvider.settings.activeUpdates == true
                              ? AppColors.widgetsColor
                              : AppColors.inActiveThumbColor),
                      activeTrackColor: AppColors.fontColor,
                      value: settingsProvider.settings.activeUpdates,
                      onChanged: (value) {
                        settingsProvider.toggleUpdates(userId);
                      },
                    ),
                  ),
                ),
              ]),
          CustomSettingsContainer(
              settingsProvider: settingsProvider,
              height: SizeConfig.getProportionalHeight(100),
              children: [
                CustomSettingTile(
                    icon: Assets.contactUs,
                    text: "contact_us",
                    givenWrittenLanguage: settingsProvider.language,
                    onTap: () => Get.to(
                        ContactUsScreen(settingsProvider: settingsProvider))),
                SizedBox(
                  child: CustomSettingTile(
                      icon: Assets.logout,
                      text: "logout",
                      givenWrittenLanguage: settingsProvider.language,
                      onTap: () {
                        AuthenticationController().logout(authenticationProvider, dashboardProvider);
                      }),
                )
              ])
        ],
      ),
    );
  }
}
