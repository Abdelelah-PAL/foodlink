import 'package:flutter/material.dart';

import '../../../controllers/sources.dart';
import '../../../core/constants/colors.dart';
import '../../../providers/meals_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../widgets/custom_text.dart';

class CustomChangeableColorButton extends StatefulWidget {
  const CustomChangeableColorButton({
    super.key,
    required this.source,
    required this.text,
    required this.tag,
    required this.mealsProvider,
    required this.settingsProvider,
  });

  final int source;
  final String tag;
  final String text;
  final MealsProvider mealsProvider;
  final SettingsProvider settingsProvider;

  @override
  State<CustomChangeableColorButton> createState() =>
      _CustomChangeableColorButtonState();
}

class _CustomChangeableColorButtonState
    extends State<CustomChangeableColorButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.source == Sources.planningMeals
            ? widget.tag == "chosen"
                ? widget.mealsProvider.onChosenTapped()
                : widget.mealsProvider.onSelfTapped()
            : widget.tag == "userMeals"
                ? widget.mealsProvider.onUserMealsTapped()
                : widget.mealsProvider.onSuggestedMealsTapped();
      },
      child: Container(
        width: 120,
        height: 50,
        decoration: BoxDecoration(
            color: widget.source == Sources.planningMeals
                ? widget.tag == "chosen"
                    ? widget.mealsProvider.chosenPressed == true
                        ? AppColors.widgetsColor
                        : Colors.transparent
                    : widget.mealsProvider.selfPressed == true
                        ? AppColors.widgetsColor
                        : Colors.transparent
                : widget.tag == "userMeals"
                    ? widget.mealsProvider.userMealsPressed == true
                        ? AppColors.widgetsColor
                        : Colors.transparent
                    : widget.mealsProvider.suggestedMealsPressed == true
                        ? AppColors.widgetsColor
                        : Colors.transparent,
            border: Border.all(
              color: AppColors.widgetsColor, // Border color
              width: 3, // Border width
            ),
            borderRadius: BorderRadius.circular(15)),
        child: Center(
          child: CustomText(
              isCenter: true,
              text: widget.text,
              fontSize: widget.settingsProvider.language == 'en' ? 12 : 16,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
