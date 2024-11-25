import 'package:flutter/material.dart';
import 'package:foodlink/controllers/user_types.dart';
import 'package:foodlink/providers/dashboard_provider.dart';
import 'package:foodlink/providers/settings_provider.dart';
import 'package:foodlink/providers/users_provider.dart';
import 'package:foodlink/screens/notifications_screen/notifications_screen.dart';
import 'package:foodlink/screens/widgets/profile_circle.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../core/constants/assets.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';
import '../../core/utils/size_config.dart';
import '../../services/translation_services.dart';

class AppHeader extends StatefulWidget {
  const AppHeader({super.key});

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    DashboardProvider dashboardProviderWatcher =
        context.watch<DashboardProvider>();
    String greeting = TranslationService().translate("greeting");
    greeting = greeting.replaceFirst(
        '{name}',
        UsersProvider().selectedUser?.username ??
            (UsersProvider().selectedUser?.userTypeId == UserTypes.user
                ? TranslationService().translate("user")
                : TranslationService().translate("cooker")));
    return Padding(
      padding: EdgeInsets.only(
        top: SizeConfig.getProportionalHeight(50),
        left: SizeConfig.getProportionalWidth(24),
        right: SizeConfig.getProportionalWidth(24),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizeConfig.customSizedBox(
                24,
                24,
                IconButton(
                  onPressed: () => Get.to(const NotificationsScreen()),
                  icon: const Icon(
                      color: Colors.black, Icons.notifications_none_outlined),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: DashboardProvider().toggleExpanded,
                      child: Container(
                        width: SizeConfig.getProportionalWidth(94),
                        height: SizeConfig.getProportionalHeight(22),
                        margin: EdgeInsets.only(
                          left: SizeConfig.getProportionalWidth(11),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.widgetsColor,
                        ),
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  bottom: SizeConfig.getProportionalHeight(20),
                                  right: SizeConfig.getProportionalWidth(11)),
                              width: SizeConfig.getProportionalWidth(8),
                              height: SizeConfig.getProportionalHeight(6),
                              child: const Icon(Icons.arrow_drop_down),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  UsersProvider().selectedUser!.userTypeId == 1
                                      ? TranslationService().translate("cooker")
                                      : TranslationService().translate("user"),
                                  style: TextStyle(
                                    fontFamily: AppFonts.primaryFont,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: SizeConfig.getProportionalWidth(20),
                              height: SizeConfig.getProportionalHeight(18),
                              margin: EdgeInsets.only(
                                  right: SizeConfig.getProportionalWidth(5)),
                              child: Image.asset(
                                  UsersProvider().selectedUser!.userTypeId == 1
                                      ? Assets.cookerBlack
                                      : Assets.userBlack),
                            ),
                          ],
                        ),
                      ),
                    ),
                    dashboardProviderWatcher.isExpanded
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                UsersProvider().toggleSelectedUser(
                                  UsersProvider().selectedUser!.userTypeId == 1
                                      ? 2
                                      : 1,
                                );
                                DashboardProvider().toggleExpanded();
                              });
                            },
                            child: Container(
                              width: SizeConfig.getProportionalWidth(94),
                              height: SizeConfig.getProportionalHeight(22),
                              margin: EdgeInsets.only(
                                left: SizeConfig.getProportionalWidth(11),
                              ),
                              decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                      color: AppColors.defaultBorderColor,
                                      blurRadius: 5),
                                ],
                                borderRadius: BorderRadius.circular(20),
                                color: AppColors.backgroundColor,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        bottom:
                                            SizeConfig.getProportionalHeight(
                                                20),
                                        right: SizeConfig.getProportionalWidth(
                                            11)),
                                    width: SizeConfig.getProportionalWidth(8),
                                    height: SizeConfig.getProportionalHeight(6),
                                  ),
                                  Expanded(
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      UsersProvider()
                                                  .selectedUser!
                                                  .userTypeId ==
                                              1
                                          ? TranslationService()
                                              .translate("user")
                                          : TranslationService()
                                              .translate("cooker"),
                                      style: TextStyle(
                                        fontFamily: AppFonts.primaryFont,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: SizeConfig.getProportionalWidth(20),
                                    height:
                                        SizeConfig.getProportionalHeight(18),
                                    margin: EdgeInsets.only(
                                        right:
                                            SizeConfig.getProportionalWidth(5)),
                                    child: Image.asset(UsersProvider()
                                                .selectedUser!
                                                .userTypeId ==
                                            1
                                        ? Assets.userBlack
                                        : Assets.cookerBlack),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : SizeConfig.customSizedBox(94, 22, null),
                  ],
                ),
              ),
              const ProfileCircle(
                height: 38,
                width: 38,
                iconSize: 25,
              ),
            ],
          ),
          Align(
            alignment: settingsProvider.language == 'en'
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Text(
              greeting,
              textDirection: settingsProvider.language == 'en'
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              style: TextStyle(
                fontSize: 15,
                fontFamily: AppFonts.primaryFont,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
