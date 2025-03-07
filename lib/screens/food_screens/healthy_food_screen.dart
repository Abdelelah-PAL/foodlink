import 'package:flutter/material.dart';
import 'package:foodlink/core/constants/colors.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/providers/settings_provider.dart';
import 'package:foodlink/providers/users_provider.dart';
import 'package:foodlink/screens/dashboard/widgets/custom_bottom_navigation_bar.dart';
import 'package:foodlink/screens/food_screens/widgets/healthy_icon_text.dart';
import 'package:foodlink/screens/widgets/custom_text.dart';
import 'package:foodlink/screens/widgets/image_container.dart';
import 'package:foodlink/services/translation_services.dart';
import 'package:provider/provider.dart';

import '../../core/constants/assets.dart';
import '../../core/constants/fonts.dart';
import '../widgets/app_header.dart';

class HealthyFoodScreen extends StatelessWidget {
  const HealthyFoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider =
        Provider.of<SettingsProvider>(context, listen: true);
    UsersProvider usersProvider =
        Provider.of<UsersProvider>(context, listen: true);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(SizeConfig.getProportionalHeight(100)),
        child: AppHeader(
          userId: usersProvider.selectedUser!.userId,
          userTypeId: usersProvider.selectedUser!.userTypeId!,
        ),
      ),
      backgroundColor: AppColors.backgroundColor,
      bottomNavigationBar:
          const CustomBottomNavigationBar(fromDashboard: false, initialIndex: 0,),
      body: Column(children: [
        Stack(
          children: [
            ImageContainer(imageUrl: Assets.healthyFoodHeaderImage),
            Positioned(
                left: SizeConfig.getProportionalWidth(39),
                child: SizeConfig.customSizedBox(
                    137, 134, Image.asset(Assets.healthyDish))),
            Positioned(
              left: SizeConfig.getProportionalWidth(230),
              child: Column(
                children: [
                  Text(
                    TranslationService().translate("healthy_dish"),
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: AppFonts.getPrimaryFont(context),
                        fontWeight: FontWeight.bold,
                        color: AppColors.backgroundColor,
                        shadows: const [
                          Shadow(
                            offset: Offset(0.5, 0.5),
                            blurRadius: 8.0,
                            color: AppColors.errorColor,
                          ),
                        ]),
                  ),
                  SizeConfig.customSizedBox(null, 10, null),
                  Text(
                    TranslationService().translate("vegetables_percent"),
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: AppFonts.getPrimaryFont(context),
                        fontWeight: FontWeight.bold,
                        color: AppColors.backgroundColor,
                        shadows: const [
                          Shadow(
                            offset: Offset(0.5, 0.5),
                            blurRadius: 8.0,
                            color: AppColors.errorColor,
                          ),
                        ]),
                  ),
                  Text(
                    TranslationService().translate("fruits_percent"),
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: AppFonts.getPrimaryFont(context),
                        fontWeight: FontWeight.bold,
                        color: AppColors.backgroundColor,
                        shadows: const [
                          Shadow(
                            offset: Offset(0.5, 0.5),
                            blurRadius: 8.0,
                            color: AppColors.errorColor,
                          ),
                        ]),
                  ),
                  Text(
                    TranslationService().translate("grains_percent"),
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: AppFonts.getPrimaryFont(context),
                        fontWeight: FontWeight.bold,
                        color: AppColors.backgroundColor,
                        shadows: const [
                          Shadow(
                            offset: Offset(0.5, 0.5),
                            blurRadius: 8.0,
                            color: AppColors.errorColor,
                          ),
                        ]),
                  ),
                  Text(
                    TranslationService().translate("protiens_percent"),
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: AppFonts.getPrimaryFont(context),
                        fontWeight: FontWeight.bold,
                        color: AppColors.backgroundColor,
                        shadows: const [
                          Shadow(
                            offset: Offset(0.5, 0.5),
                            blurRadius: 8.0,
                            color: AppColors.errorColor,
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: SizeConfig.getProportionalHeight(20)),
          child: settingsProvider.language == "en"
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    HealthyIconText(
                      icon: Assets.measurement,
                      text: "measurements",
                      settingsProvider: settingsProvider,
                    ),
                    SizeConfig.customSizedBox(20, null, null),
                    HealthyIconText(
                        icon: Assets.calories,
                        text: "calories",
                        settingsProvider: settingsProvider),
                    SizeConfig.customSizedBox(20, null, null),
                    HealthyIconText(
                        icon: Assets.nutritionSystem,
                        text: "nutrition_system",
                        settingsProvider: settingsProvider),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    HealthyIconText(
                        icon: Assets.nutritionSystem,
                        text: "nutrition_system",
                        settingsProvider: settingsProvider),
                    SizeConfig.customSizedBox(20, null, null),
                    HealthyIconText(
                        icon: Assets.calories,
                        text: "calories",
                        settingsProvider: settingsProvider),
                    SizeConfig.customSizedBox(20, null, null),
                    HealthyIconText(
                        icon: Assets.measurement,
                        text: "measurements",
                        settingsProvider: settingsProvider),
                  ],
                ),
        ),
        Align(
          alignment: settingsProvider.language == 'en'
              ? Alignment.centerLeft
              : Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.getProportionalWidth(20)),
            child: const CustomText(
                isCenter: false,
                text: "chosen_healthy_meals",
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        )
      ]),
    );
  }
}
