import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/size_config.dart';
import '../../../providers/meals_provider.dart';
import '../../../providers/settings_provider.dart';

class IngredientBox extends StatelessWidget {
  const IngredientBox({super.key,
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
    bool isEn = settingsProvider.language == 'en';
    int quantity = mealsProvider.ingredientQuantities.length > index ? mealsProvider.ingredientQuantities[index] : 1;

    Widget quantityAdjuster = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            if (quantity > 1) {
              mealsProvider.updateIngredientQuantity(index, -1);
            } else {
              mealsProvider.removeIngredient(index);
            }
          },
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(color: AppColors.widgetsColor, shape: BoxShape.circle),
            child: const Center(child: Icon(Icons.remove, size: 14, color: Colors.black)),
          ),
        ),
        const SizedBox(width: 8),
        Text('$quantity', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => mealsProvider.updateIngredientQuantity(index, 1),
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(color: AppColors.widgetsColor, shape: BoxShape.circle),
            child: const Center(child: Icon(Icons.add, size: 14, color: Colors.black)),
          ),
        ),
      ],
    );

    Widget textField = Expanded(
      child: TextField(
        controller: controller,
        textDirection: isEn ? TextDirection.ltr : TextDirection.rtl,
        textAlign: isEn ? TextAlign.left : TextAlign.right,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: SizeConfig.getProportionalWidth(10)),
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );

    List<Widget> rowChildren = isEn
        ? [textField, VerticalDivider(color: Colors.grey.shade300, width: 1, thickness: 1), const SizedBox(width: 8), quantityAdjuster, const SizedBox(width: 8)]
        : [const SizedBox(width: 8), quantityAdjuster, const SizedBox(width: 8), VerticalDivider(color: Colors.grey.shade300, width: 1, thickness: 1), textField];

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: SizeConfig.getProportionalHeight(5),
        horizontal: SizeConfig.getProportionalWidth(3),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(width: 2.0, color: AppColors.widgetsColor),
      ),
      child: Row(
        children: rowChildren,
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
          margin: EdgeInsets.symmetric(
            vertical: SizeConfig.getProportionalHeight(5),
            horizontal: SizeConfig.getProportionalWidth(3),
          ),
          decoration: BoxDecoration(
            color: AppColors.widgetsColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(Icons.add, size: 30, color: Colors.black)),
    );
  }
}
