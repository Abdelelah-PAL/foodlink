import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../core/utils/size_config.dart';
import '../../../models/meal.dart';
import '../../../services/translation_services.dart';
import '../../widgets/custom_back_button.dart';

class MealImageContainer extends StatelessWidget {
  const MealImageContainer({super.key, required this.isAddSource, this.meal});

  final bool isAddSource;
  final Meal? meal;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Container(
            width: SizeConfig.screenWidth,
            height: SizeConfig.getProportionalHeight(203),
            padding: EdgeInsets.zero,
            decoration: const BoxDecoration(
                color: AppColors.widgetsColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  // Bottom-left corner radius
                  bottomRight:
                      Radius.circular(15), // Bottom-right corner radius
                ),
                border: Border(
                  bottom:
                      BorderSide(width: 1, color: AppColors.defaultBorderColor),
                )),
            child: !isAddSource &&
                    meal != null &&
                    meal!.imageUrl!.isNotEmpty &&
                    meal!.imageUrl != null
                ? Image.asset(
                    meal!.imageUrl!,
                    fit: BoxFit.fill,
                  )
                : null,
          ),
          const CustomBackButton(),
          if (isAddSource)
            Positioned.fill(
              child: Center(
                child: GestureDetector(
                  onTap: () {},
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(TranslationService().translate("upload_food_image"),
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: AppFonts.primaryFont)),
                      SizeConfig.customSizedBox(
                        10,
                        null,
                        null,
                      ),
                      const Icon(Icons.file_upload_outlined)
                    ],
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
