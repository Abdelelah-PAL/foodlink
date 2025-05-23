import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/assets.dart';
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
import '../../widgets/image_container.dart';
import 'feature_container.dart';
import 'meal_tile.dart';

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
    return FutureBuilder<Map<String, dynamic>?>(
      future: mealsProvider.fetchLatestDishOfTheWeek(),
      builder: (context, snapshot) {
        Widget overlay = const SizedBox(); // default: no overlay

        if (snapshot.hasData && snapshot.data != null) {
          final data = snapshot.data!;
          final String imageUrl = data['imageUrl'];
          final double widthRatio = (data['width'] as num).toDouble();
          final double heightRatio = (data['height'] as num).toDouble();
          final double dx = (data['position']['x'] as num).toDouble();
          final double dy = (data['position']['y'] as num).toDouble();

          overlay = Positioned(
            left: 332 * dx,
            top: 142 * dy,
            child: SizeConfig.customSizedBox(
              332 * widthRatio,
              142 * heightRatio,
              Image.network(
                imageUrl,
                fit: BoxFit.fitHeight,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error),
              ),
            ),
          );
        }

        return Column(children: [
          SizedBox(
            width: SizeConfig.getProportionalWidth(332),
            height: SizeConfig.getProportionalHeight(127),
            child: Stack(
              children: [
                ImageContainer(imageUrl: Assets.dishOfTheWeek),
                overlay,
              ],
            ),
          ),
          SizeConfig.customSizedBox(null, 10, null),
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
          SizeConfig.customSizedBox(
            332,
            500,
            Consumer<FeaturesProvider>(
                builder: (context, featuresProvider, child) {
              return ListView.builder(
                itemCount: featuresProvider.cookerFeatures.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (ctx, index) {
                  final feature = featuresProvider.cookerFeatures[index];
                  VoidCallback onTap = () {};
                  switch (feature.keyword) {
                    case "Calories":
                      onTap = () {
                        Get.to(const BeyondCaloriesArticlesScreen());
                      };
                      break;
                    case "Planning":
                      onTap = () {
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
            }),
          )
        ]);
      },
    );
  }
}
