import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodlink/controllers/user_types.dart';
import 'package:foodlink/core/constants/fonts.dart';
import 'package:foodlink/models/user_details.dart';
import 'package:foodlink/providers/general_provider.dart';
import 'package:foodlink/providers/users_provider.dart';
import 'package:foodlink/screens/dashboard/dashboard.dart';
import 'package:foodlink/screens/home_screen/home_screen.dart';
import 'package:foodlink/services/translation_services.dart';
import 'package:get/get.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/size_config.dart';

class RoleTile extends StatelessWidget {
  const RoleTile(
      {super.key,
      required this.imageUrl,
      required this.roleId,
      required this.user});

  final String imageUrl;
  final int roleId;
  final User user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: SizeConfig.getProportionalWidth(20)),
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.getProportionalWidth(20)),
          child: Row(
            mainAxisAlignment: GeneralProvider().language == "en"
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            children: [
              if (GeneralProvider().language == "en") ...[
                Container(
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
                    child: Center(child: Image.asset(imageUrl))),
                SizedBox(width: SizeConfig.getProportionalWidth(15)),
                Column(
                  children: [
                    Text(
                      roleId == UserTypes.cooker
                          ? TranslationService().translate("cooker")
                          : TranslationService().translate("user"),
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
                        roleId == UserTypes.cooker
                            ? TranslationService().translate("cook_one")
                            : TranslationService().translate("use_one"),
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: AppFonts.primaryFont,
                        ),
                      ),
                    ),
                  ],
                )
              ] else ...[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      roleId == UserTypes.cooker
                          ? TranslationService().translate("cooker")
                          : TranslationService().translate("user"),
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
                        roleId == UserTypes.cooker
                            ? TranslationService().translate("cook_one")
                            : TranslationService().translate("use_one"),
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily: AppFonts.primaryFont,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: SizeConfig.getProportionalWidth(15)),
                Container(
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
                    child: Center(child: Image.asset(imageUrl))),
              ]
            ],
          ),
        ),
      ),
    );
  }

  void onTap() async {
    UsersProvider().selectedUser =
        await UsersProvider().getUserByRoleAndId(user.uid!, roleId);
    Get.to(const Dashboard());
  }
}
