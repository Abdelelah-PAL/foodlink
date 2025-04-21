import 'package:flutter/material.dart';
import 'package:foodlink/controllers/general_controller.dart';
import '../../../controllers/meal_controller.dart';
import '../../../providers/meals_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../widgets/custom_text.dart';

class CheckboxTile extends StatelessWidget {
  const CheckboxTile({
    super.key,
    required this.text,
    required this.settingsProvider,
    required this.mealsProvider,
    required this.index,
    required this.ingredientsLength,
  });

  final String text;
  final SettingsProvider settingsProvider;
  final MealsProvider mealsProvider;
  final int index;
  final int ingredientsLength;

  @override
  Widget build(BuildContext context) {
    String writtenLanguage = GeneralController().detectLanguage(text);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      textDirection: settingsProvider.language == 'en'
          ? TextDirection.rtl
          : TextDirection.ltr,
      children: [
        CustomText(
          isCenter: false,
          text: text,
          fontSize: writtenLanguage == 'en' ? 20 : 14,
          fontWeight: FontWeight.normal,
          maxLines: 2,
        ),
        Checkbox(
          value: mealsProvider.checkboxValues[index],
          onChanged: (bool? value) {
            mealsProvider.toggleCheckedIngredient(value, index);
            if (value == true) {
              MealController().missingIngredients.add(text);
            } else {
              MealController().missingIngredients.remove(text);
            }
          },
        )
      ],
    );
  }
}
