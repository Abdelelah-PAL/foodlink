import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../controllers/sources.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';
import '../../core/utils/size_config.dart';
import '../../providers/meal_categories_provider.dart';
import '../../providers/meals_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/users_provider.dart';
import '../../services/translation_services.dart';
import '../dashboard/dashboard.dart';
import '../dashboard/widgets/custom_bottom_navigation_bar.dart';
import 'add_meal_screen.dart';
import 'widgets/add_box.dart';
import 'widgets/custom_changeable_color_button.dart';
import 'widgets/list_header.dart';
import 'widgets/list_meal_tile.dart';

class MealsListScreen extends StatefulWidget {
  const MealsListScreen(
      {super.key, required this.index, required this.categoryId});

  final int index;
  final int categoryId;

  @override
  State<MealsListScreen> createState() => _MealsListScreenState();
}

class _MealsListScreenState extends State<MealsListScreen> {
  final mealCategories = MealCategoriesProvider().mealCategories;

  @override
  void initState() {
    MealsProvider().getAllMealsByCategory(
        widget.categoryId, UsersProvider().selectedUser!.userId);
    MealsProvider().getAllSuggestedMealsByCategory(widget.categoryId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MealsProvider mealsProviderWatcher = context.watch<MealsProvider>();
    SettingsProvider settingsProvider = context.watch<SettingsProvider>();

    return mealsProviderWatcher.isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: AppColors.backgroundColor,
            appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(SizeConfig.getProportionalHeight(100)),
              child: SafeArea(
                child: ListHeader(
                  text: TranslationService()
                      .translate(mealCategories[widget.index].mealsName),
                  isEmpty: mealsProviderWatcher.meals.isEmpty,
                  backOnTap: () {
                    Get.to(const Dashboard(initialIndex: 0));
                  },
                  favorites: false,
                  onTap: () {
                    Get.to(AddMealScreen(
                      categoryId: widget.categoryId,
                      isAddScreen: true,
                      isUpdateScreen: false,
                      backButtonCallBack: () {
                        Get.to(MealsListScreen(
                            index: widget.index,
                            categoryId: widget.categoryId));
                        MealsProvider().resetValues();
                      },
                    ));
                  },
                ),
              ),
            ),
            bottomNavigationBar: const CustomBottomNavigationBar(
              fromDashboard: false,
              initialIndex: 0,
            ),
            body: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomChangeableColorButton(
                      source: Sources.categoryMeals,
                      text: "your_meals",
                      tag: 'userMeals',
                      mealsProvider: mealsProviderWatcher,
                      settingsProvider: settingsProvider,
                    ),
                    SizeConfig.customSizedBox(40, null, null),
                    CustomChangeableColorButton(
                      source: Sources.categoryMeals,
                      text: "suggested_meals",
                      tag: 'suggestedMeals',
                      mealsProvider: mealsProviderWatcher,
                      settingsProvider: settingsProvider,
                    ),
                  ],
                ),

                /// 🔹 CONTENT (SCROLLABLE)
                Expanded(
                  child: mealsProviderWatcher.userMealsPressed
                      ? _userMealsSection(context)
                      : _suggestedMealsSection(context),
                ),
              ],
            ),
          );
  }

  Widget _userMealsSection(BuildContext context) {
    return Consumer<MealsProvider>(
      builder: (context, mealsProvider, child) {
        if (mealsProvider.meals.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(
                    AddMealScreen(
                      categoryId: widget.categoryId,
                      isAddScreen: true,
                      isUpdateScreen: false,
                      backButtonCallBack: () {
                        Get.to(
                          MealsListScreen(
                            index: widget.index,
                            categoryId: widget.categoryId,
                          ),
                        );
                        MealsProvider().resetValues();
                      },
                    ),
                  );
                },
                child: const AddBox(),
              ),
              const SizedBox(height: 20),
              Text(
                TranslationService().translate("add_first_meal"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: AppFonts.getPrimaryFont(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        }

        return ListView.builder(
          itemCount: mealsProvider.meals.length,
          itemBuilder: (ctx, index) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.getProportionalHeight(20),
                vertical: SizeConfig.getProportionalHeight(10),
              ),
              child: ListMealTile(
                meal: mealsProvider.meals[index],
                favorites: false,
                source: 'default',
              ),
            );
          },
        );
      },
    );
  }

  Widget _suggestedMealsSection(BuildContext context) {
    return Consumer<MealsProvider>(
      builder: (context, mealsProvider, child) {
        if (mealsProvider.suggestions.isEmpty) {
          return Center(
            child: Text(
              TranslationService().translate("no_suggested_meals"),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontFamily: AppFonts.getPrimaryFont(context),
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: mealsProvider.suggestions.length,
          itemBuilder: (ctx, index) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.getProportionalHeight(20),
                vertical: SizeConfig.getProportionalHeight(10),
              ),
              child: ListMealTile(
                meal: mealsProvider.suggestions[index],
                favorites: false,
                source: 'default',
              ),
            );
          },
        );
      },
    );
  }
}
