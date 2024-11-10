import 'package:flutter/material.dart';
import 'package:foodlink/controllers/meal_controller.dart';
import 'package:foodlink/core/constants/assets.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/main.dart';
import 'package:foodlink/models/meal.dart';
import 'package:foodlink/providers/meals_provider.dart';
import 'package:foodlink/screens/food_screens/widgets/custom_meal_textfield.dart';
import 'package:foodlink/screens/widgets/custom_back_button.dart';
import 'package:foodlink/screens/widgets/custom_button.dart';
import 'package:foodlink/services/translation_services.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../providers/users_provider.dart';

class AddMealScreen extends StatelessWidget {
  AddMealScreen({super.key, required this.categoryId});

  final int categoryId;
  MealController mealController = MealController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: SizeConfig.screenWidth,
                      height: SizeConfig.getProportionalHeight(203),
                      padding: EdgeInsets.zero,
                      decoration: const BoxDecoration(
                          color: AppColors.widgetsColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            // Bottom-left corner radius
                            bottomRight: Radius.circular(
                                15), // Bottom-right corner radius
                          ),
                          border: Border(
                            bottom: BorderSide(
                                width: 1, color: AppColors.defaultBorderColor),
                          )),
                    ),
                    const CustomBackButton(),
                    Positioned.fill(
                      child: Center(
                        child: GestureDetector(
                          onTap: () {},
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  TranslationService()
                                      .translate("upload_food_image"),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: AppFonts.primaryFont)),
                              SizedBox(
                                width: SizeConfig.getProportionalWidth(10),
                              ),
                              const Icon(Icons.file_upload_outlined)
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: SizeConfig.getProportionalHeight(20),
                ),
                CustomMealTextField(
                  width: SizeConfig.getProportionalWidth(348),
                  height: SizeConfig.getProportionalHeight(37),
                  hintText: TranslationService().translate("meal_name"),
                  icon: Assets.mealNameIcon,
                  controller: mealController.nameController,
                  maxLines: 2,
                ),
                CustomMealTextField(
                  width: SizeConfig.getProportionalWidth(348),
                  height: SizeConfig.getProportionalHeight(161),
                  hintText: TranslationService().translate("ingredients"),
                  icon: Assets.mealIngredients,
                  controller: mealController.ingredientsController,
                  maxLines: 5,
                ),
                CustomMealTextField(
                  width: SizeConfig.getProportionalWidth(348),
                  height: SizeConfig.getProportionalHeight(161),
                  hintText: TranslationService().translate("recipe"),
                  icon: Assets.mealRecipe,
                  controller: mealController.recipeController,
                  maxLines: 10,
                ),
                SizedBox(
                  height: SizeConfig.getProportionalHeight(20),
                ),
                CustomButton(
                  onTap: () {
                    MealsProvider().addMeal(Meal(
                        categoryId: categoryId,
                        name: mealController.nameController.text,
                        ingredients: mealController.ingredientsController.text,
                        recipe: mealController.recipeController.text,
                        imageUrl: Assets.sweets,
                        userId:  UsersProvider().selectedUser!.userId!));
                  },
                  text: TranslationService().translate("confirm"),
                  width: SizeConfig.getProportionalWidth(126),
                  height: SizeConfig.getProportionalHeight(45),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
