import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';
import '../../core/utils/size_config.dart';
import '../../providers/meal_categories_provider.dart';
import '../../providers/meals_provider.dart';
import '../../providers/users_provider.dart';
import '../../services/translation_services.dart';
import '../widgets/custom_text.dart';
import 'widgets/list_meal_tile.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  final mealCategories = MealCategoriesProvider().mealCategories;

  @override
  void initState() {
    MealsProvider().getFavorites(UsersProvider().selectedUser!.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MealsProvider mealsProviderWatcher = context.watch<MealsProvider>();
    return mealsProviderWatcher.isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: AppColors.backgroundColor,
            appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(SizeConfig.getProportionalHeight(100)),
              child:  Padding(
                padding: EdgeInsets.only(top: SizeConfig.getProportionalHeight(30)),
                child: const SafeArea(
                    child: CustomText(
                  isCenter: true,
                  text: "favorites",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
              ),
            ),
            body: mealsProviderWatcher.favoriteMeals.isEmpty
                ? SizeConfig.customSizedBox(
                    null,
                    null,
                    Center(
                      child: Text(
                        TranslationService().translate("no_favorites"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30,
                            fontFamily: AppFonts.getPrimaryFont(context),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                : Consumer<MealsProvider>(
                    builder: (context, mealsProvider, child) {
                      return ListView.builder(
                        itemCount: mealsProvider.favoriteMeals.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (ctx, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                              top: SizeConfig.getProportionalHeight(20),
                              right: SizeConfig.getProportionalHeight(20),
                              left: SizeConfig.getProportionalHeight(20),
                            ),
                            child: ListMealTile(
                                meal: mealsProvider.favoriteMeals[index],
                                favorites: true,
                              source: 'favorites',),
                          );
                        },
                      );
                    },
                  ),
          );
  }
}
