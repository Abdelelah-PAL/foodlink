import 'package:flutter/material.dart';
import 'package:foodlink/controllers/dashboard_controller.dart';
import 'package:foodlink/core/constants/fonts.dart';
import 'package:foodlink/models/user_details.dart';
import 'package:foodlink/providers/dashboard_provider.dart';
import 'package:foodlink/providers/features_provider.dart';
import 'package:foodlink/providers/notification_provider.dart';
import 'package:foodlink/providers/users_provider.dart';
import 'package:foodlink/services/translation_services.dart';
import 'package:provider/provider.dart';
import '../../../controllers/user_types.dart';
import '../../../core/constants/assets.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/size_config.dart';
import '../../../providers/settings_provider.dart';
import 'username_textfield.dart';

class CookerTile extends StatelessWidget {
  const CookerTile(
      {super.key,
      required this.dashboardProvider,
      required this.settingsProvider});

  final DashboardProvider dashboardProvider;
  final SettingsProvider settingsProvider;

  @override
  Widget build(BuildContext context) {
    UsersProvider usersProvider = context.read<UsersProvider>();
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: SizeConfig.getProportionalWidth(20),
          horizontal: SizeConfig.getProportionalWidth(20)),
      child: Row(
        mainAxisAlignment: settingsProvider.language == "en"
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: [
          if (settingsProvider.language == "en") ...[
            GestureDetector(
              onTap: () async {
                DashboardProvider().changeRole(UserTypes.cooker);
                UserDetails cooker = usersProvider.loggedInUsers.firstWhere(
                  (user) => user.userTypeId == UserTypes.cooker,
                );
                usersProvider.setFirstLogin(cooker, UserTypes.cooker);

                DashboardProvider().togglePressed(UserTypes.cooker);
                DashboardController().userNameController.clear();
                await NotificationsProvider()
                    .getAllNotifications(cooker.userTypeId, cooker.userId);
                await FeaturesProvider().getAllFeatures();
              },
              child: Container(
                  height: SizeConfig.getProportionalHeight(116),
                  width: SizeConfig.getProportionalWidth(120),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: AppColors.backgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 7,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Center(
                      child: Image.asset(dashboardProvider.cookerPressed
                          ? Assets.pressedCooker
                          : Assets.cooker))),
            ),
            SizeConfig.customSizedBox(15, null, null),
            dashboardProvider.cookerPressed == true &&
                    usersProvider.cookerFirstLogin == true
                ? UsernameTextField(
                    controller: DashboardController().cookerNameController,
                    hintText:
                        TranslationService().translate("enter_cooker_name"))
                : Column(
                    children: [
                      Text(
                        TranslationService().translate("cooker"),
                        style: TextStyle(
                            fontSize: 25,
                            fontFamily: AppFonts.getPrimaryFont(context),
                            fontWeight: FontWeight.bold),
                      ),
                      SizeConfig.customSizedBox(
                        170,
                        null,
                        Text(
                          textDirection: TextDirection.ltr,
                          textAlign: TextAlign.center,
                          TranslationService().translate("cook_one"),
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: AppFonts.getPrimaryFont(context),
                          ),
                        ),
                      ),
                    ],
                  )
          ] else ...[
            dashboardProvider.cookerPressed == true &&
                    usersProvider.cookerFirstLogin == true
                ? UsernameTextField(
                    controller: DashboardController().cookerNameController,
                    hintText:
                        TranslationService().translate("enter_cooker_name"))
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        TranslationService().translate("cooker"),
                        style: TextStyle(
                            fontSize: 25,
                            fontFamily: AppFonts.getPrimaryFont(context),
                            fontWeight: FontWeight.bold),
                      ),
                      SizeConfig.customSizedBox(
                        170,
                        null,
                        Text(
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,
                          TranslationService().translate("cook_one"),
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: AppFonts.getPrimaryFont(context),
                          ),
                        ),
                      ),
                    ],
                  ),
            SizeConfig.customSizedBox(15, null, null),
            GestureDetector(
              onTap: () async{
                DashboardProvider().changeRole(UserTypes.cooker);
                UserDetails cooker = usersProvider.loggedInUsers.firstWhere(
                  (user) => user.userTypeId == UserTypes.cooker,
                );
                usersProvider.setFirstLogin(cooker, UserTypes.cooker);

                DashboardProvider().togglePressed(UserTypes.cooker);
                DashboardController().userNameController.clear();
                await NotificationsProvider()
                    .getAllNotifications(cooker.userTypeId, cooker.userId);
                await FeaturesProvider().getAllFeatures();
              },
              child: Container(
                  height: SizeConfig.getProportionalHeight(116),
                  width: SizeConfig.getProportionalWidth(120),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: AppColors.backgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 7,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Center(
                      child: Image.asset(dashboardProvider.cookerPressed
                          ? Assets.pressedCooker
                          : Assets.cooker))),
            ),
          ]
        ],
      ),
    );
  }
}
