import 'package:flutter/material.dart';
import 'package:foodlink/core/constants/assets.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/providers/meal_categories_provider.dart';
import 'package:foodlink/screens/home_screen/widgets/feature_container.dart';
import 'package:foodlink/screens/home_screen/widgets/meal_tile.dart';
import 'package:foodlink/screens/widgets/custom_text.dart';
import 'package:foodlink/services/translation_services.dart';
import 'package:provider/provider.dart';
import '../../../providers/settings_provider.dart';

class UserBody extends StatelessWidget {
  const UserBody({super.key, required this.settingsProvider});

  final SettingsProvider settingsProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: settingsProvider.language == "en"
              ? Alignment.centerLeft
              : Alignment.centerRight,
          child: CustomText(
              text: TranslationService().translate("wht_want_eat"),
              fontSize: 20,
              fontWeight: FontWeight.w700,
              isCenter: false),
        ),
        Container(
          padding: EdgeInsets.only(
              top: SizeConfig.getProportionalHeight(5),
              bottom: SizeConfig.getProportionalHeight(25),
              left: SizeConfig.getProportionalWidth(15)),
          width: SizeConfig.getProportionalWidth(500),
          height: SizeConfig.getProportionalHeight(270),
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
                  final category = mealCategoriesProvider.mealCategories[index];
                  return MealTile(
                    name: category.name,
                    imageUrl: category.imageUrl,
                    width: 85,
                    height: 85,
                    index: index,
                    categoryId: category.id!,
                  );
                },
              );
            },
          ),
        ),
        FeatureContainer(
            imageUrl: Assets.healthyFood,
            text: TranslationService().translate("healthy_food"),
            settingsProvider: settingsProvider),
        FeatureContainer(
            imageUrl: Assets.aestheticFood,
            text: TranslationService().translate("aesthetic_food"),
            settingsProvider: settingsProvider),
      ],
    );
  }
}
