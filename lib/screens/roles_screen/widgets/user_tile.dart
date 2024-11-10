import 'package:flutter/material.dart';
import 'package:foodlink/controllers/dashboard_controller.dart';
import 'package:foodlink/core/constants/fonts.dart';
import 'package:foodlink/providers/dashboard_provider.dart';
import 'package:foodlink/providers/general_provider.dart';
import 'package:foodlink/screens/roles_screen/widgets/username_textfield.dart';
import 'package:foodlink/services/translation_services.dart';
import 'package:provider/provider.dart';
import '../../../controllers/user_types.dart';
import '../../../core/constants/assets.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/size_config.dart';
import '../../../models/user_details.dart';
import '../../../providers/users_provider.dart';

class UserTile extends StatelessWidget {
  const UserTile({super.key, required this.dashboardProvider});

  final DashboardProvider dashboardProvider;

  @override
  Widget build(BuildContext context) {
    UsersProvider usersProvider = context.watch<UsersProvider>();
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: SizeConfig.getProportionalWidth(2),
          horizontal: SizeConfig.getProportionalWidth(20)),
      child: Row(
        mainAxisAlignment: GeneralProvider().language == "en"
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: [
          if (GeneralProvider().language == "en") ...[
            GestureDetector(
              onTap: () {
                DashboardProvider().changeRole(UserTypes.user);
                UserDetails user = usersProvider.loggedInUsers.firstWhere(
                  (user) => user.userTypeId == UserTypes.user,
                );
                usersProvider.setFirstLogin(user, UserTypes.user);
                DashboardProvider().togglePressed(UserTypes.user);
                DashboardController().cookerNameController.clear();
              },
              child: Container(
                  height: SizeConfig.getProportionalHeight(116),
                  width: SizeConfig.getProportionalWidth(120),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: AppColors.backgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        offset: const Offset(6, 6),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                      // Light shadow for highlight
                      const BoxShadow(
                        color: Colors.white,
                        offset: Offset(-10, -10),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Center(
                      child: Image.asset(dashboardProvider.userPressed
                          ? Assets.pressedUser
                          : Assets.user))),
            ),
            SizedBox(width: SizeConfig.getProportionalWidth(15)),
            dashboardProvider.userPressed && usersProvider.userFirstLogin == true
                ? UsernameTextField(
                    controller: DashboardController().userNameController,
                    hintText: TranslationService().translate("enter_user_name"))
                : Column(
                    children: [
                      Text(
                        TranslationService().translate("user"),
                        style: TextStyle(
                            fontSize: 25,
                            fontFamily: AppFonts.primaryFont,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: SizeConfig.getProportionalWidth(170),
                        child: Text(
                          textDirection: TextDirection.ltr,
                          textAlign: TextAlign.center,
                          TranslationService().translate("use_one"),
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: AppFonts.primaryFont,
                          ),
                        ),
                      ),
                    ],
                  )
          ] else ...[
            dashboardProvider.userPressed && usersProvider.userFirstLogin == true
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
                            fontFamily: AppFonts.primaryFont,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: SizeConfig.getProportionalWidth(170),
                        child: Text(
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.center,
                          TranslationService().translate("use_one"),
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: AppFonts.primaryFont,
                          ),
                        ),
                      ),
                    ],
                  ),
            SizedBox(width: SizeConfig.getProportionalWidth(15)),
            GestureDetector(
              onTap: () {
                DashboardProvider().changeRole(UserTypes.user);
                UserDetails user = usersProvider.loggedInUsers.firstWhere(
                  (user) => user.userTypeId == UserTypes.user,
                );
                usersProvider.setFirstLogin(user, UserTypes.user);
                DashboardProvider().togglePressed(UserTypes.user);
                DashboardController().cookerNameController.clear();
              },
              child: Container(
                  height: SizeConfig.getProportionalHeight(116),
                  width: SizeConfig.getProportionalWidth(120),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: AppColors.backgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade600,
                        offset: const Offset(6, 6),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                      // Light shadow for highlight
                      const BoxShadow(
                        color: Colors.white,
                        offset: Offset(-10, -10),
                        blurRadius: 5,
                        spreadRadius: 1,
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
