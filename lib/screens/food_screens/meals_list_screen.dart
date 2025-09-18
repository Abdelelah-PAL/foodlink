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
            body: SingleChildScrollView(
              child: Column(
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
                  mealsProviderWatcher.userMealsPressed == true
                      ? mealsProviderWatcher.meals.isEmpty
                          ? Column(
                              children: [
                                SizeConfig.customSizedBox(null, SizeConfig.getProperVerticalSpace(5), null),
                                GestureDetector(
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
                                        }));
                                  },
                                  child: const AddBox(),
                                ),
                                SizeConfig.customSizedBox(null, 20, null),
                                Text(
                                  TranslationService()
                                      .translate("add_first_meal"),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontFamily:
                                          AppFonts.getPrimaryFont(context),
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            )
                          : Consumer<MealsProvider>(
                              builder: (context, mealsProvider, child) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: mealsProvider.meals.length,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (ctx, index) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        top: SizeConfig.getProportionalHeight(20),
                                        right:
                                            SizeConfig.getProportionalHeight(20),
                                        left:
                                            SizeConfig.getProportionalHeight(20),
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
                            )
                      : mealsProviderWatcher.suggestions.isEmpty
                          ? Column(
                            children: [

                              SizeConfig.customSizedBox(null, SizeConfig.screenHeight! / 4, null),
                              Text(
                                TranslationService()
                                    .translate("no_suggested_meals"),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 30,
                                    fontFamily:
                                        AppFonts.getPrimaryFont(context),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                          : Consumer<MealsProvider>(
                              builder: (context, mealsProvider, child) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: mealsProvider.suggestions.length,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (ctx, index) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        top: SizeConfig.getProportionalHeight(20),
                                        right:
                                            SizeConfig.getProportionalHeight(20),
                                        left:
                                            SizeConfig.getProportionalHeight(20),
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
                            )
                ],
              ),
            ),
          );
  }
}
