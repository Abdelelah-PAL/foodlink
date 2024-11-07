import 'package:flutter/material.dart';
import 'package:foodlink/core/constants/assets.dart';
import 'package:foodlink/core/constants/fonts.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/providers/general_provider.dart';
import 'package:foodlink/providers/meal_categories_provider.dart';
import 'package:foodlink/screens/home_screen/widgets/feature_container.dart';
import 'package:foodlink/screens/home_screen/widgets/meal_tile.dart';
import 'package:foodlink/services/translation_services.dart';
import 'package:provider/provider.dart';

class UserBody extends StatelessWidget {
  const UserBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(top: SizeConfig.getProportionalHeight(0)),
      child: Column(
        children: [
          Align(
            alignment: GeneralProvider().language == "en"
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Text(
              TranslationService().translate("wht_want_eat"),
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontFamily: AppFonts.primaryFont),
            ),
          ),
          SizedBox(
            height: SizeConfig.getProportionalHeight(5),
          ),
          Padding(
            padding:
            EdgeInsets.only(bottom: SizeConfig.getProportionalHeight(25)),
            child: SizedBox(
              width: SizeConfig.getProportionalWidth(500),
              height: SizeConfig.getProportionalHeight(250),
              child: Consumer<MealCategoriesProvider>(
                builder: (context, mealCategoriesProvider, child) {
                  return GridView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: mealCategoriesProvider.mealCategories.length,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 0,
                      crossAxisSpacing: 0,
                      childAspectRatio: 0.85,
                    ),
                    itemBuilder: (ctx, index) {
                      final category =
                      mealCategoriesProvider.mealCategories[index];
                      return MealTile(
                          name: category.name,
                          imageUrl: category.imageUrl,
                          width: 99,
                          height: 99);
                    },
                  );
                },
              ),
            ),
          ),
          FeatureContainer(
            imageUrl: Assets.healthyFood,
            text: TranslationService().translate("healthy_food"),
          ),
          FeatureContainer(
            imageUrl: Assets.aestheticFood,
            text: TranslationService().translate("aesthetic_food"),
          ),
        ],
      ),
    );
  }
}