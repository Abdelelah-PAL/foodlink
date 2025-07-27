import 'package:flutter/material.dart';
import 'package:foodlink/controllers/dashboard_controller.dart';
import 'package:foodlink/core/constants/fonts.dart';
import 'package:foodlink/providers/dashboard_provider.dart';
import 'package:foodlink/screens/roles_screen/widgets/username_textfield.dart';
import 'package:foodlink/services/translation_services.dart';
import 'package:provider/provider.dart';
import '../../../controllers/user_types.dart';
import '../../../core/constants/assets.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/size_config.dart';
import '../../../models/user_details.dart';
import '../../../providers/features_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../providers/users_provider.dart';

class UserTile extends StatelessWidget {
  const UserTile(
      {super.key,
      required this.dashboardProvider,
      required this.settingsProvider});

  final DashboardProvider dashboardProvider;
  final SettingsProvider settingsProvider;

  @override
  Widget build(BuildContext context) {
    UsersProvider usersProvider = context.watch<UsersProvider>();
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: SizeConfig.getProportionalWidth(2),
          horizontal: SizeConfig.getProportionalWidth(20)),
      child: Row(
        mainAxisAlignment: settingsProvider.language == "en"
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: [
          if (settingsProvider.language == "en") ...[
            GestureDetector(
              onTap: () async {
                DashboardProvider().changeRole(UserTypes.user);
                UserDetails user = usersProvider.loggedInUsers.firstWhere(
                  (user) => user.userTypeId == UserTypes.user,
                );
                usersProvider.setFirstLogin(user, UserTypes.user);
                DashboardProvider().togglePressed(UserTypes.user);
                DashboardController().cookerNameController.clear();
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
                      child: Image.asset(dashboardProvider.userPressed
                          ? Assets.pressedUser
                          : Assets.user))),
            ),
            SizeConfig.customSizedBox(15, null, null),
            dashboardProvider.userPressed &&
                    usersProvider.userFirstLogin == true
                ? UsernameTextField(
                    controller: DashboardController().userNameController,
                    hintText: TranslationService().translate("enter_user_name"))
                : Column(
                    children: [
                      Text(
                        TranslationService().translate("user"),
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
                          TranslationService().translate("use_one"),
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: AppFonts.getPrimaryFont(context),
                          ),
                        ),
                      ),
                    ],
                  )
          ]
          else ...[

            dashboardProvider.userPressed &&
                    usersProvider.userFirstLogin == true
                ? UsernameTextField(
                    controller: DashboardController().userNameController,
                    hintText: TranslationService().translate("enter_user_name"))
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        TranslationService().translate("user"),
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
                          TranslationService().translate("use_one"),
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
              onTap: () async {
                print(usersProvider.userFirstLogin);

                DashboardProvider().changeRole(UserTypes.user);
                UserDetails user = usersProvider.loggedInUsers.firstWhere(
                  (user) => user.userTypeId == UserTypes.user,
                );
                usersProvider.setFirstLogin(user, UserTypes.user);
                DashboardProvider().togglePressed(UserTypes.user);
                DashboardController().cookerNameController.clear();
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
                      child: Image.asset(dashboardProvider.userPressed
                          ? Assets.pressedUser
                          : Assets.user))),
            ),
          ]
        ],
      ),
    );
  }
}
