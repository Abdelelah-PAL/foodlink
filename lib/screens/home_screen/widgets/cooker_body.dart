import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/size_config.dart';
import '../../../models/user_details.dart';
import '../../../providers/features_provider.dart';
import '../../../providers/meal_categories_provider.dart';
import '../../../providers/meals_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../services/translation_services.dart';
import '../../beyond_calories_articles_screen/beyond_calories_articles_screen.dart';
import '../../food_screens/meal_planning_screen.dart';
import '../../widgets/custom_text.dart';
import 'feature_container.dart';
import 'meal_tile.dart';
import 'auto_slider.dart'; // 👈 import slider widget

class CookerBody extends StatelessWidget {
  final SettingsProvider settingsProvider;
  final MealsProvider mealsProvider;
  final FeaturesProvider featuresProvider;
  final UserDetails userDetails;

  const CookerBody({
    super.key,
    required this.settingsProvider,
    required this.mealsProvider,
    required this.featuresProvider,
    required this.userDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AutoSlider(),

        SizeConfig.customSizedBox(null, 10, null),

        /// Meals title
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

        SizeConfig.customSizedBox(null, 5, null),

        /// Meal categories
        Padding(
          padding: EdgeInsets.only(
            bottom: SizeConfig.getProportionalHeight(25),
          ),
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

        /// Features list
        Expanded(
          child: Consumer<FeaturesProvider>(
            builder: (context, featuresProvider, child) {
              return ListView.builder(
                itemCount: featuresProvider.cookerFeatures.length,
                itemBuilder: (ctx, index) {
                  final feature = featuresProvider.cookerFeatures[index];

                  VoidCallback onTap = () {};

                  switch (feature.keyword) {
                    case "Calories":
                      onTap = () {
                        context.read<FeaturesProvider>().getAllArticles();
                        Get.to(const BeyondCaloriesArticlesScreen());
                      };
                      break;

                    case "Planning":
                      onTap = () {
                        context.read<MealsProvider>().getAllPlannedMeals();
                        Get.to(const MealPlanningScreen());
                      };
                      break;
                  }

                  return FeatureContainer(
                    imageUrl: settingsProvider.language == 'en'
                        ? feature.enImageURL
                        : feature.arImageURL,
                    onTap: onTap,
                    active: feature.active,
                    premium: feature.premium,
                    user: userDetails,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
