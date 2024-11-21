import 'package:flutter/material.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/providers/meals_provider.dart';
import '../../../core/constants/colors.dart';
import '../../../providers/settings_provider.dart';

class IngredientBox extends StatelessWidget {
  const IngredientBox(
      {super.key, required this.settingsProvider, required this.controller});

  final TextEditingController controller;
  final SettingsProvider settingsProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.getProportionalWidth(80),
      height: SizeConfig.getProportionalHeight(40),
      margin: EdgeInsets.symmetric(
        vertical: SizeConfig.getProportionalHeight(10),
        horizontal: SizeConfig.getProportionalWidth(3),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(width: 1.0, color: AppColors.widgetsColor),
      ),
      child: TextField(
        controller: controller,
        textAlign: settingsProvider.language == 'en'
            ? TextAlign.left
            : TextAlign.right,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(
              SizeConfig.getProportionalWidth(10),
              SizeConfig.getProportionalHeight(0),
              SizeConfig.getProportionalWidth(10),
              SizeConfig.getProportionalHeight(15)),
          border: InputBorder.none,
        ),
      ),
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
          width: SizeConfig.getProportionalWidth(80),
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
