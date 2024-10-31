import 'package:flutter/material.dart';

import '../../../core/constants/assets.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../core/utils/size_config.dart';
import '../../../providers/general_provider.dart';
import '../../../services/translation_services.dart';

class HomeScreenHeader extends StatelessWidget {
  const HomeScreenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.getProportionalWidth(20)),      child: Row(
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
              horizontal: SizeConfig.getProportionalWidth(80),
            ),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.primaryColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                      bottom: SizeConfig.getProportionalHeight(20),
                    ),
                    width: SizeConfig.getProportionalWidth(8),
                    height: SizeConfig.getProportionalHeight(6),
                    child: const Icon(Icons.arrow_drop_down),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    width: SizeConfig.getProportionalWidth(20),
                    height: SizeConfig.getProportionalHeight(20),
                    child: Text(
                      GeneralProvider().selectedUser!.userTypeId == 1
                          ? TranslationService().translate("cooker")
                          : TranslationService().translate("user"),
                      style: TextStyle(
                        fontFamily: AppFonts.primaryFont,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    width: SizeConfig.getProportionalWidth(20),
                    height: SizeConfig.getProportionalHeight(18),
                    child: Image.asset(
                        GeneralProvider().selectedUser!.userTypeId == 1
                            ? Assets.cookerBlack
                            : Assets.userBlack),
                  ),
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
      ),
    );
  }
}
