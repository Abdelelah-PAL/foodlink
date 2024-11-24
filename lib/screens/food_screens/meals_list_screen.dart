import 'package:flutter/material.dart';
import 'package:foodlink/core/constants/colors.dart';
import 'package:foodlink/core/constants/fonts.dart';
import 'package:foodlink/providers/meals_provider.dart';
import 'package:foodlink/providers/users_provider.dart';
import 'package:foodlink/screens/dashboard/widgets/custom_bottom_navigation_bar.dart';
import 'package:foodlink/screens/food_screens/add_meal_screen.dart';
import 'package:foodlink/screens/food_screens/widgets/list_header.dart';
import 'package:foodlink/screens/food_screens/widgets/list_meal_tile.dart';
import 'package:foodlink/services/translation_services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../core/utils/size_config.dart';
import '../../providers/meal_categories_provider.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MealsProvider mealsProviderWatcher = context.watch<MealsProvider>();
    return mealsProviderWatcher.isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(SizeConfig.getProportionalHeight(100)),
              child: SafeArea(
                child: ListHeader(
                  text: TranslationService()
                      .translate(mealCategories[widget.index].mealsName),
                  isEmpty: mealsProviderWatcher.meals.isEmpty,
                  categoryId: widget.categoryId,
                  favorites: false,
                ),
              ),
            ),
            bottomNavigationBar: const CustomBottomNavigationBar(
              fromDashboard: false,
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.getProportionalWidth(20),
              ),
              child: mealsProviderWatcher.meals.isEmpty
                  ? SizeConfig.customSizedBox(
                      null,
                      null,
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.to(AddMealScreen(
                                  categoryId: widget.categoryId,
                                  isAddScreen: true,
                                ));
                              },
                              child: Container(
                                width: SizeConfig.getProportionalWidth(105),
                                height: SizeConfig.getProportionalHeight(73),
                                decoration: BoxDecoration(
                                  color: AppColors.widgetsColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Icon(Icons.add),
                              ),
                            ),
                            SizeConfig.customSizedBox(null, 20, null),
                            Text(
                              TranslationService().translate("add_first_meal"),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: AppFonts.primaryFont,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    )
                  : Consumer<MealsProvider>(
                      builder: (context, mealsProvider, child) {
                        return Padding(
                          padding: EdgeInsets.only(
                              top: SizeConfig.getProportionalHeight(20)),
                          child: ListView.builder(
                            itemCount: mealsProvider.meals.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (ctx, index) {
                              return ListMealTile(
                                  meal: mealsProvider.meals[index],
                                  favorites: false);
                            },
                          ),
                        );
                      },
                    ),
            ),
          );
  }
}
