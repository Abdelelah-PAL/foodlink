import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodlink/controllers/dashboard_controller.dart';
import 'package:foodlink/controllers/user_types.dart';
import 'package:foodlink/providers/dashboard_provider.dart';
import 'package:foodlink/providers/general_provider.dart';
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
import '../../providers/users_provider.dart';
import '../../services/translation_services.dart';
import '../dashboard/dashboard.dart';

class RolesScreen extends StatelessWidget {
  const RolesScreen({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    DashboardProvider dashboardProvider = context.watch<DashboardProvider>();
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
                    alignment: GeneralProvider().language == "en"
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Text(
                      TranslationService().translate("choose_role"),
                      textDirection: GeneralProvider().language == "en"
                          ? TextDirection.ltr
                          : TextDirection.rtl,
                      textAlign: GeneralProvider().language == "en"
                          ? TextAlign.left
                          : TextAlign.right,
                      style: TextStyle(
                          fontFamily: AppFonts.primaryFont,
                          fontSize:
                              GeneralProvider().language == "en" ? 25 : 30,
                          color: AppColors.fontColor,
                          fontWeight: FontWeight.bold),
                      softWrap: false,
                    ),
                  ),
                ),
                UserTile(
                  dashboardProvider: dashboardProvider,
                ),
                CookerTile(
                  dashboardProvider: dashboardProvider,
                ),
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
                          .getUserByRoleAndId(
                              user.uid, dashboardProvider.roleId);
                      MealCategoriesProvider().getAllMealCategories();
                      Get.to(const Dashboard());
                    },
                    text: TranslationService().translate("next"),
                    width: SizeConfig.getProportionalWidth(216),
                    height: SizeConfig.getProportionalHeight(45))
              ])),
        ));
  }
}
