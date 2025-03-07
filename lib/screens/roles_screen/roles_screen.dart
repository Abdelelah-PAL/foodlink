import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodlink/controllers/dashboard_controller.dart';
import 'package:foodlink/controllers/user_types.dart';
import 'package:foodlink/providers/beyond_calories_articles_provider.dart';
import 'package:foodlink/providers/dashboard_provider.dart';
import 'package:foodlink/screens/roles_screen/widgets/cooker_tile.dart';
import 'package:foodlink/screens/roles_screen/widgets/user_tile.dart';
import 'package:foodlink/screens/widgets/custom_button.dart';
import 'package:foodlink/services/users_services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../core/constants/assets.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';
import '../../core/utils/size_config.dart';
import '../../providers/meal_categories_provider.dart';
import '../../providers/meals_provider.dart';
import '../../providers/notification_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/users_provider.dart';
import '../../services/translation_services.dart';
import '../dashboard/dashboard.dart';

class RolesScreen extends StatelessWidget {
  const RolesScreen({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    DashboardProvider dashboardProvider = context.watch<DashboardProvider>();
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.backgroundColor,
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.getProportionalWidth(70),
                  horizontal: SizeConfig.getProportionalWidth(10)),
              child: Column(children: [
                SizeConfig.customSizedBox(
                    179, 179, Image.asset(Assets.pureLogo)),
                SizeConfig.customSizedBox(null, 20, null),
                Padding(
                  padding: EdgeInsets.only(
                      top: SizeConfig.getProportionalHeight(10),
                      bottom: SizeConfig.getProportionalHeight(13),
                      left: SizeConfig.getProportionalWidth(20),
                      right: SizeConfig.getProportionalWidth(20)),
                  child: Align(
                    alignment: settingsProvider.language == "en"
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Text(
                      TranslationService().translate("choose_role"),
                      textDirection: settingsProvider.language == "en"
                          ? TextDirection.ltr
                          : TextDirection.rtl,
                      textAlign: settingsProvider.language == "en"
                          ? TextAlign.left
                          : TextAlign.right,
                      style: TextStyle(
                          fontFamily: AppFonts.getPrimaryFont(context),
                          fontSize: settingsProvider.language == "en" ? 25 : 30,
                          color: AppColors.fontColor,
                          fontWeight: FontWeight.bold),
                      softWrap: false,
                    ),
                  ),
                ),
                UserTile(
                    dashboardProvider: dashboardProvider,
                    settingsProvider: settingsProvider),
                CookerTile(
                    dashboardProvider: dashboardProvider,
                    settingsProvider: settingsProvider),
                SizeConfig.customSizedBox(null, 50, null),
                CustomButton(
                  onTap: () async {
                    int roleId = dashboardProvider.roleId;
                    TextEditingController controller =
                        roleId == UserTypes.cooker
                            ? DashboardController().cookerNameController
                            : DashboardController().userNameController;
                    await UsersServices()
                        .updateUsername(user.uid, roleId, controller.text);
                    UsersProvider().selectedUser = await UsersProvider()
                        .getUserByRoleAndId(user.uid, dashboardProvider.roleId);
                    BeyondCaloriesArticlesProvider().getAllArticles();
                    MealCategoriesProvider().getAllMealCategories();
                    MealsProvider().getAllPlannedMeals();
                    await NotificationsProvider().getAllNotifications(
                        UsersProvider().selectedUser!.userTypeId,
                        UsersProvider().selectedUser!.userId);
                    Get.to(const Dashboard(
                      initialIndex: 0,
                    ));
                  },
                  text: TranslationService().translate("next"),
                  width: SizeConfig.getProportionalWidth(216),
                  height: SizeConfig.getProportionalHeight(45),
                  isDisabled: true,
                )
              ])),
        ));
  }
}
