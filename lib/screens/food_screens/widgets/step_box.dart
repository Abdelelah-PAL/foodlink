import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/size_config.dart';
import '../../../providers/meals_provider.dart';
import '../../../providers/settings_provider.dart';

class StepBox extends StatelessWidget {
  const StepBox(
      {super.key,
      required this.settingsProvider,
      required this.controller,
      required this.mealsProvider,
      required this.index});

  final TextEditingController controller;
  final SettingsProvider settingsProvider;
  final MealsProvider mealsProvider;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: SizeConfig.getProportionalWidth(348),
          height: SizeConfig.getProportionalHeight(66),
          margin: EdgeInsets.symmetric(
            vertical: SizeConfig.getProportionalHeight(5),
            horizontal: SizeConfig.getProportionalWidth(3),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: 3.0, color: AppColors.widgetsColor),
          ),
          child: TextField(
            controller: controller,
            textDirection: settingsProvider.language == 'en'
                ? TextDirection.ltr
                : TextDirection.rtl,
            // For right-to-left text
            textAlign: settingsProvider.language == 'en'
                ? TextAlign.left
                : TextAlign.right,
            style: const TextStyle(fontSize: 12),
            // Set font size here
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                  SizeConfig.getProportionalWidth(10),
                  SizeConfig.getProportionalHeight(0),
                  SizeConfig.getProportionalWidth(10),
                  SizeConfig.getProportionalHeight(15)),
              border: InputBorder.none,
            ),
          ),
        ),
        Positioned(
            left: 0,
            top: 0,
            child: IconButton(
                onPressed: () {
                  mealsProvider.removeStep(index);
                },
                icon: const Icon(Icons.highlight_remove_rounded, size: 22, color: Colors.grey,)))
      ],
    );
  }
}

class AddStepBox extends StatelessWidget {
  const AddStepBox({super.key, required this.mealsProvider});

  final MealsProvider mealsProvider;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: mealsProvider.increaseSteps,
      child: Container(
          width: SizeConfig.getProportionalWidth(348),
          height: SizeConfig.getProportionalHeight(66),
          margin: EdgeInsets.symmetric(
            vertical: SizeConfig.getProportionalHeight(5),
            horizontal: SizeConfig.getProportionalWidth(3),
          ),
          decoration: BoxDecoration(
            color: AppColors.widgetsColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(Icons.add)),
    );
  }
}
