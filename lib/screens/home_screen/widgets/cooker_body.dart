import 'package:flutter/material.dart';
import 'package:foodlink/core/constants/assets.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/providers/meal_categories_provider.dart';
import 'package:foodlink/screens/food_screens/healthy_food.dart';
import 'package:foodlink/screens/food_screens/meal_planning.dart';
import 'package:foodlink/screens/food_screens/weekly_meals_planning_screen.dart';
import 'package:foodlink/screens/home_screen/widgets/feature_container.dart';
import 'package:foodlink/screens/home_screen/widgets/meal_tile.dart';
import 'package:foodlink/screens/widgets/custom_text.dart';
import 'package:foodlink/screens/widgets/image_container.dart';
import 'package:foodlink/services/translation_services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../providers/settings_provider.dart';
import '../../beyond_calories_articles_screen/beyond_calories_articles_screen.dart';

class CookerBody extends StatelessWidget {
  const CookerBody({super.key, required this.settingsProvider});

  final SettingsProvider settingsProvider;

  @override
  Widget build(BuildContext context) {
    bool dowExists = true;
    return FutureBuilder(
        future: Assets.dishOfTheWeekReference,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            dowExists = false;
          }

          return Column(
            children: [
              Stack(
                children: [
                  ImageContainer(imageUrl: Assets.dishOfTheWeek),
                  Positioned(
                    left: SizeConfig.getProportionalWidth(80),
                    bottom: SizeConfig.getProportionalHeight(10),
                    top: SizeConfig.getProportionalHeight(10),
                    child: SizeConfig.customSizedBox(
                      138,
                      138,
                      dowExists == false ? null : Image.network(snapshot.data!),
                    ),
                  ),
                ],
              ),
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
                padding: EdgeInsets.only(
                    bottom: SizeConfig.getProportionalHeight(25)),
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
                text: TranslationService().translate("healthy_life"),
                settingsProvider: settingsProvider,
                onTap: () => Get.to(const BeyondCaloriesArticlesScreen()),
              ),
              FeatureContainer(
                imageUrl: Assets.resourcesAdvertising,
                text: TranslationService().translate("resources_advertising"),
                settingsProvider: settingsProvider,
                onTap: () => Get.to(const WeeklyMealsPlanningScreen()),
              ),
              FeatureContainer(
                left: SizeConfig.getProportionalWidth(18),
                imageUrl: Assets.aestheticFood,
                text: TranslationService().translate("aesthetic_food"),
                settingsProvider: settingsProvider,
                onTap: () => Get.to(const HealthyFood()),
              ),
              FeatureContainer(
                left: SizeConfig.getProportionalWidth(35),
                imageUrl: Assets.mealPlanning,
                text: TranslationService().translate("meal_planning"),
                settingsProvider: settingsProvider,
                onTap: () => Get.to(const MealPlanning()),
              ),
            ],
          );
        });
  }
}
