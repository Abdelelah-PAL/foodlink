import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:foodlink/core/constants/assets.dart';
import 'package:foodlink/core/constants/fonts.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/providers/general_provider.dart';
import 'package:foodlink/providers/meal_categories_provider.dart';
import 'package:foodlink/providers/users_provider.dart';
import 'package:foodlink/screens/home_screen/widgets/meal_tile.dart';
import 'package:foodlink/services/translation_services.dart';
import 'package:provider/provider.dart';

class CookerBody extends StatelessWidget {
  const CookerBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: SizeConfig.getProportionalWidth(332),
          height: SizeConfig.getProportionalHeight(142),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          child: Image.asset(Assets.dishOfTheWeek, fit: BoxFit.fill),
        ),
        SizedBox(
          height: SizeConfig.getProperHorizontalSpace(10),
        ),
        Align(
          alignment: GeneralProvider().language == "en"
              ? Alignment.centerLeft
              : Alignment.centerRight,
          child: Text(
            TranslationService().translate("meals"),
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontFamily: AppFonts.primaryFont),
          ),
        ),
        SizedBox(
          height: SizeConfig.getProperHorizontalSpace(20),
        ),
        SizedBox(
          width: SizeConfig.getProportionalWidth(332),
          height: SizeConfig.getProportionalHeight(104),
          child: Consumer<MealCategoriesProvider>(
            builder: (context, mealCategoriesProvider, child) {
              return ListView.builder(
                itemCount: mealCategoriesProvider.mealCategories.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, index) {
                  final category = mealCategoriesProvider.mealCategories[index];
                  return MealTile(name: category.name, imageUrl: category.imageUrl);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}