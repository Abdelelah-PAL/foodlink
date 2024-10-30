import 'package:flutter/material.dart';
import 'package:foodlink/core/constants/assets.dart';
import 'package:foodlink/core/constants/colors.dart';
import 'package:foodlink/core/constants/fonts.dart';
import 'package:foodlink/providers/general_provider.dart';
import 'package:foodlink/services/translation_services.dart';

import '../../core/utils/size_config.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print(GeneralProvider().selectedUser!.userTypeId);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.getProportionalHeight(56)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: SizeConfig.getProportionalWidth(24),
                  height: SizeConfig.getProportionalHeight(24),
                  child: const Icon(
                      color: Colors.black, Icons.notifications_none_outlined),
                ),
                Container(
                  width: SizeConfig.getProportionalWidth(94),
                  height: SizeConfig.getProportionalHeight(22),
                  margin: EdgeInsets.symmetric(
                    horizontal: SizeConfig.getProportionalWidth(98),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.primaryColor,
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: SizeConfig.getProportionalWidth(8),
                        height: SizeConfig.getProportionalHeight(6),
                        child: const Icon(Icons.arrow_drop_down),
                      ),
                      Text(
                        GeneralProvider().selectedUser!.userTypeId == 1
                            ? TranslationService().translate("cooker")
                            : TranslationService().translate("user"),
                        style: TextStyle(
                          fontFamily: AppFonts.primaryFont,
                        ),
                      ),
                      SizedBox(
                        width: SizeConfig.getProportionalWidth(20),
                        height: SizeConfig.getProportionalHeight(18),
                        child: Image.asset(
                            GeneralProvider().selectedUser!.userTypeId == 1
                                ? Assets.cookerBlack
                                : Assets.userBlack),
                      )
                    ],
                  ),
                ),
                Container(
                  width: SizeConfig.getProportionalWidth(38),
                  height: SizeConfig.getProportionalHeight(38),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryColor,
                  ),
                  child: const Icon(Icons.person_outline_outlined),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
