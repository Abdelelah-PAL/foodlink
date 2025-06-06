import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/size_config.dart';
import '../../../providers/meals_provider.dart';
import '../../../providers/settings_provider.dart';

class IngredientBox extends StatelessWidget {
  const IngredientBox(
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
          width: SizeConfig.getProportionalWidth(110),
          height: SizeConfig.getProportionalHeight(40),
          margin: EdgeInsets.symmetric(
            vertical: SizeConfig.getProportionalHeight(10),
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
            textAlign: settingsProvider.language == 'en'
                ? TextAlign.left
                : TextAlign.right,
            style: const TextStyle(fontSize: 12),
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
            left: -5,
            top: 0,
            child: IconButton(
                onPressed: () {
                  mealsProvider.removeIngredient(index);
                },
                icon: const Icon(Icons.highlight_remove_rounded, size: 18, color: Colors.grey,)))
      ],
    );
  }
}

class AddIngredientBox extends StatelessWidget {
  const AddIngredientBox({super.key, required this.mealsProvider});

  final MealsProvider mealsProvider;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: mealsProvider.increaseIngredients,
      child: Container(
          width: SizeConfig.getProportionalWidth(110),
          height: SizeConfig.getProportionalHeight(40),
          margin: EdgeInsets.symmetric(
            vertical: SizeConfig.getProportionalHeight(10),
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
