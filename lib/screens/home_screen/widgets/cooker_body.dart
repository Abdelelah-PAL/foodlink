import 'package:flutter/material.dart';
import 'package:foodlink/core/constants/assets.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/providers/meal_categories_provider.dart';
import 'package:foodlink/screens/food_screens/healthy_food.dart';
import 'package:foodlink/screens/home_screen/widgets/feature_container.dart';
import 'package:foodlink/screens/home_screen/widgets/meal_tile.dart';
import 'package:foodlink/screens/widgets/custom_text.dart';
import 'package:foodlink/screens/widgets/image_container.dart';
import 'package:foodlink/services/translation_services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../providers/settings_provider.dart';

class CookerBody extends StatelessWidget {
  const CookerBody({super.key, required this.settingsProvider});

  final SettingsProvider settingsProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ImageContainer(imageUrl: Assets.dishOfTheWeek),
        SizeConfig.customSizedBox(
          null,
          10,
          null,
        ),
        Align(
          alignment: settingsProvider.language == "en"
              ? Alignment.centerLeft
              : Alignment.centerRight,
          child: CustomText(
            text: TranslationService().translate("meals"),
            isCenter: false,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizeConfig.customSizedBox(
          null,
          5,
          null,
        ),
        Padding(
          padding:
              EdgeInsets.only(bottom: SizeConfig.getProportionalHeight(25)),
          child: SizeConfig.customSizedBox(
            332,
            95,
            Consumer<MealCategoriesProvider>(
              builder: (context, mealCategoriesProvider, child) {
                return ListView.builder(
                  itemCount: mealCategoriesProvider.mealCategories.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, index) {
                    final category =
                        mealCategoriesProvider.mealCategories[index];
                    return MealTile(
                      name: category.name,
                      imageUrl: category.imageUrl,
                      width: 66,
                      height: 55,
                      index: index,
                      categoryId: category.id!,
                    );
                  },
                );
              },
            ),
          ),
        ),
        FeatureContainer(
          imageUrl: Assets.healthyFood,
          text: TranslationService().translate("healthy_food"),
          settingsProvider: settingsProvider,
          onTap: () => Get.to(const HealthyFood()),
        ),
        FeatureContainer(
          imageUrl: Assets.resourcesAdvertising,
          text: TranslationService().translate("resources_advertising"),
          settingsProvider: settingsProvider,
          onTap: () => Get.to(const HealthyFood()),
        ),
      ],
    );
  }
}
