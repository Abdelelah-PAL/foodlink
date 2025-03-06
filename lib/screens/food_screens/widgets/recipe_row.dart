import 'package:flutter/material.dart';
import 'package:foodlink/controllers/general_controller.dart';
import 'package:foodlink/controllers/user_types.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/providers/settings_provider.dart';
import 'package:foodlink/providers/users_provider.dart';
import '../../../core/constants/assets.dart';
import '../../../models/meal.dart';

class RecipeRow extends StatelessWidget {
  const RecipeRow({
    super.key,
    required this.meal,
    required this.fontSize,
    required this.settingsProvider,
    required this.usersProvider,
xx  });

  final Meal meal;
  final double fontSize;
  final SettingsProvider settingsProvider;
  final UsersProvider usersProvider;

  @override
  Widget build(BuildContext context) {
    String writtenLanguage = GeneralController().detectLanguage(meal.recipe!);

    return Row(
      textDirection: settingsProvider.language == 'en'
          ? TextDirection.ltr
          : TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(Assets.mealRecipe),
        SizeConfig.customSizedBox(
          280,
          usersProvider.selectedUser!.userTypeId == UserTypes.cooker ? 200 : 225,
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Text(
              maxLines: 100,
              meal.recipe!,
              textDirection: writtenLanguage == 'en'
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              textAlign:
                  writtenLanguage == 'en' ? TextAlign.end : TextAlign.start,
              style: TextStyle(
                  fontSize: fontSize,
                  fontFamily:
                      writtenLanguage == 'en' ? 'salsa' : 'MyriadArabic'),
            ),
          ),
        ),
      ],
    );
  }
}
