import 'package:flutter/material.dart';
import 'package:foodlink/core/constants/colors.dart';
import 'package:foodlink/providers/meals_provider.dart';
import 'package:foodlink/screens/widgets/custom_text.dart';

class CustomChangeableColorButton extends StatefulWidget {
  const CustomChangeableColorButton(
      {super.key, required this.tag, required this.mealsProvider});

  final String tag;
  final MealsProvider mealsProvider;

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
        widget.tag == "chosen"
            ? widget.mealsProvider.onChosenTapped()
            : widget.mealsProvider.onSelfTapped();
      },
      child: Container(
        width: 120,
        height: 50,
        decoration: BoxDecoration(
            color: widget.tag == "chosen"
                ? widget.mealsProvider.chosenPressed == true
                    ? AppColors.widgetsColor
                    : Colors.transparent
                : widget.mealsProvider.selfPressed == true
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
              text: widget.tag == "chosen"
                  ? "chosen_meal_plan_inline"
                  : "your_weekly_plan",
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
