import 'package:flutter/material.dart';
import 'package:foodlink/providers/users_provider.dart';
import '../../../core/constants/assets.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../core/utils/size_config.dart';
import '../../../services/translation_services.dart';

class HomeScreenHeader extends StatefulWidget {
  const HomeScreenHeader({super.key, required this.onUpdate});

  final VoidCallback onUpdate;

  @override
  State<HomeScreenHeader> createState() => _HomeScreenHeaderState();
}

class _HomeScreenHeaderState extends State<HomeScreenHeader> {
  bool isExpanded = false;

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
        Expanded(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
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
              isExpanded
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          UsersProvider().toggleSelectedUser(
                            UsersProvider().selectedUser!.userTypeId == 1 ? 2 : 1,
                          );
                          isExpanded = !isExpanded;
                        });
                        widget.onUpdate();
                      },
                      child: Container(
                        width: SizeConfig.getProportionalWidth(94),
                        height: SizeConfig.getProportionalHeight(22),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.backgroundColor,
                        ),
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  bottom: SizeConfig.getProportionalHeight(20),
                                  right: SizeConfig.getProportionalWidth(11)),
                              width: SizeConfig.getProportionalWidth(8),
                              height: SizeConfig.getProportionalHeight(6),
                            ),
                            Expanded(
                              child: Text(
                                textAlign: TextAlign.center,
                                UsersProvider().selectedUser!.userTypeId == 1
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
                                  right: SizeConfig.getProportionalWidth(5)),
                              child: Image.asset(
                                  UsersProvider().selectedUser!.userTypeId == 1
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
