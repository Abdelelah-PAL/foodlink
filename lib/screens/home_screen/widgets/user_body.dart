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

class UserBody extends StatelessWidget {
  const UserBody(
      {super.key, required this.settingsProvider, required this.userDetails});

  final SettingsProvider settingsProvider;
  final UserDetails userDetails;

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
        SizeConfig.customSizedBox(
          332,
          500,
          Consumer<FeaturesProvider>(
              builder: (context, featuresProvider, child) {
            return ListView.builder(
              itemCount: featuresProvider.userFeatures.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (ctx, index) {
                final feature = featuresProvider.userFeatures[index];
                VoidCallback onTap = () {};
                switch (feature.keyword) {
                  case "Calories":
                    onTap = () {
                      FeaturesProvider().getAllArticles();
                      Get.to(const BeyondCaloriesArticlesScreen());
                    };
                    break;
                  case "Planning":
                    onTap = () {
                      MealsProvider().getAllPlannedMeals();
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
      ],
    );
  }
}
