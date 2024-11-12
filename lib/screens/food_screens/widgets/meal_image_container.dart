import 'package:flutter/material.dart';
import 'package:foodlink/controllers/meal_controller.dart';
import 'package:foodlink/providers/meals_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../core/utils/size_config.dart';
import '../../../models/meal.dart';
import '../../../services/translation_services.dart';
import '../../widgets/custom_back_button.dart';

class MealImageContainer extends StatefulWidget {
  const MealImageContainer({super.key, required this.isAddSource, this.meal, this.mealsProvider});

  final bool isAddSource;
  final Meal? meal;
  final MealsProvider? mealsProvider;

  @override
  State<MealImageContainer> createState() => _MealImageContainerState();
}

class _MealImageContainerState extends State<MealImageContainer> {

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
            child: !widget.isAddSource &&
                    widget.meal != null &&
                    widget.meal!.imageUrl!.isNotEmpty &&
                    widget.meal!.imageUrl != null
                ? Image.network(
                    widget.meal!.imageUrl!,
                    fit: BoxFit.fill,
                  )
                : null,
          ),
          const CustomBackButton(),
          if (widget.isAddSource)
            Positioned.fill(
              child: Center(
                child: GestureDetector(
                  onTap: () async {
                    widget.mealsProvider!.imageUrl =
                        await MealsProvider().pickImageFromSource(context);
                  },
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
            ),
          if (widget.mealsProvider!.imageIsUploaded)
            Container(
              width: SizeConfig.screenWidth,
              height: SizeConfig.getProportionalHeight(203),
              padding: EdgeInsets.zero,
              decoration: const BoxDecoration(
                  color: AppColors.widgetsColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight:
                    Radius.circular(15),
                  ),
                  border: Border(
                    bottom:
                    BorderSide(width: 1, color: AppColors.defaultBorderColor),
                  )),
              child: Image.network(
                widget.mealsProvider!.imageUrl!,
                fit: BoxFit.fill,
              ),
            ),
        ],
      ),
    );
  }
}
