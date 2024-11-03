import 'package:flutter/material.dart';
import 'package:foodlink/controllers/user_types.dart';
import 'package:foodlink/models/user_details.dart';
import 'package:foodlink/providers/users_provider.dart';
import 'package:get/get.dart';

import '../../../core/constants/assets.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../core/utils/size_config.dart';
import '../../../providers/general_provider.dart';
import '../../../services/translation_services.dart';

class HomeScreenHeader extends StatefulWidget {
  const HomeScreenHeader({super.key});

  @override
  State<HomeScreenHeader> createState() => _HomeScreenHeaderState();
}

class _HomeScreenHeaderState extends State<HomeScreenHeader> {
  bool isExpanded = false;

  void toggleDropdown() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  void toggleUserType() async {
    if (GeneralProvider().selectedUser!.userTypeId == UserTypes.cooker) {
      GeneralProvider().selectedUser = await UsersProvider().getUserByRoleAndId(
          GeneralProvider().selectedUser!.userId, UserTypes.user);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: SizeConfig.getProportionalWidth(24),
          height: SizeConfig.getProportionalHeight(24),
          child: const Icon(
              color: Colors.black, Icons.notifications_none_outlined),
        ),
        Column(
          children: [
            GestureDetector(
              onTap: toggleDropdown,
              child: Container(
                width: SizeConfig.getProportionalWidth(94),
                height: SizeConfig.getProportionalHeight(22),
                margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.getProportionalWidth(75),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.primaryColor,
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
                    Center(
                      child: Text(
                        GeneralProvider().selectedUser!.userTypeId == 1
                            ? TranslationService().translate("cooker")
                            : TranslationService().translate("user"),
                        style: TextStyle(
                          fontFamily: AppFonts.primaryFont,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      width: SizeConfig.getProportionalWidth(20),
                      height: SizeConfig.getProportionalHeight(18),
                      margin: EdgeInsets.only(
                          right: SizeConfig.getProportionalWidth(5)),
                      child: Image.asset(
                          GeneralProvider().selectedUser!.userTypeId == 1
                              ? Assets.cookerBlack
                              : Assets.userBlack),
                    ),
                  ],
                ),
              ),
            ),
            isExpanded
                ? GestureDetector(
                    onTap: toggleUserType,
                    child: Container(
                      width: SizeConfig.getProportionalWidth(94),
                      height: SizeConfig.getProportionalHeight(22),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.backgroundColor,
                      ),
                      padding: EdgeInsets.only(
                          left: SizeConfig.getProportionalWidth(20)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              GeneralProvider().selectedUser!.userTypeId == 1
                                  ? TranslationService().translate("user")
                                  : TranslationService().translate("cooker"),
                              style: TextStyle(
                                fontFamily: AppFonts.primaryFont,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Container(
                            width: SizeConfig.getProportionalWidth(20),
                            height: SizeConfig.getProportionalHeight(18),
                            margin: EdgeInsets.only(
                                right: SizeConfig.getProportionalWidth(7)),
                            child: Image.asset(
                                GeneralProvider().selectedUser!.userTypeId == 1
                                    ? Assets.userBlack
                                    : Assets.cookerBlack),
                          ),
                        ],
                      ),
                    ),
                  )
                : SizedBox(
                    width: SizeConfig.getProportionalWidth(94),
                    height: SizeConfig.getProportionalHeight(22),
                  ),
          ],
        ),
        Container(
          width: SizeConfig.getProportionalWidth(38),
          height: SizeConfig.getProportionalHeight(38),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryColor,
          ),
          child: const Icon(Icons.person_outline_outlined),
        ),
      ],
    );
  }
}
