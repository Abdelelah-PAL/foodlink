import 'package:flutter/material.dart';
import 'package:foodlink/controllers/home_controller.dart';
import 'package:foodlink/core/constants/colors.dart';
import 'package:foodlink/core/constants/fonts.dart';
import 'package:foodlink/providers/meals_provider.dart';
import 'package:foodlink/providers/users_provider.dart';
import 'package:foodlink/screens/food_screens/widgets/add_meal_screen.dart';
import 'package:foodlink/screens/food_screens/widgets/list_header.dart';
import 'package:foodlink/screens/home_screen/widgets/custom_bottom_navigation_bar.dart';
import 'package:foodlink/services/translation_services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../core/utils/size_config.dart';
import '../../providers/meal_categories_provider.dart';

class MealsListScreen extends StatefulWidget {
  const MealsListScreen({super.key, required this.index});

  final int index;

  @override
  State<MealsListScreen> createState() => _MealsListScreenState();
}

class _MealsListScreenState extends State<MealsListScreen> {
  final mealCategories = MealCategoriesProvider().mealCategories;

  @override
  void initState() {
    MealsProvider().getAllMealsByCategory(widget.index,UsersProvider().selectedUser!.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MealsProvider mealsProviderWatcher = context.watch<MealsProvider>();
    return mealsProviderWatcher.isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(SizeConfig.getProportionalHeight(100)), // Set your desired height
              child: ListHeader(
                  text: TranslationService()
                      .translate(mealCategories[widget.index].mealsName)),
            ),
            bottomNavigationBar:
                CustomBottomNavigationBar(homeController: HomeController()),
            body: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.getProportionalWidth(20),
                  ),
              child: mealsProviderWatcher.meals.isEmpty
                  ? SizedBox(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {Get.to(AddMealScreen(categoryId: widget.index));},
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
                          SizedBox(height: SizeConfig.getProportionalHeight(20)),
                          Text(
                            TranslationService().translate("add_first_meal"),
                            textAlign: TextAlign.center,
                            style:  TextStyle(
                              fontSize: 30,
                              fontFamily: AppFonts.primaryFont,
                              fontWeight: FontWeight.bold
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                  : Consumer<MealsProvider>(
                      builder: (context, mealsProvider, child) {
                        return ListView.builder(
                          itemCount: mealsProvider.meals.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (ctx, index) {
                            return const ListTile();
                          },
                        );
                      },
                    ),
            ),
          );
  }
}
