import 'package:flutter/material.dart';
import 'package:foodlink/controllers/meal_controller.dart';
import 'package:foodlink/core/constants/assets.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/models/meal.dart';
import 'package:foodlink/providers/meals_provider.dart';
import 'package:foodlink/screens/widgets/custom_app_iconic_textfield.dart';
import 'package:foodlink/screens/food_screens/widgets/ingredient_box.dart';
import 'package:foodlink/screens/food_screens/widgets/meal_image_container.dart';
import 'package:foodlink/screens/widgets/custom_button.dart';
import 'package:foodlink/services/translation_services.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../widgets/custom_text.dart';

class AddMealScreen extends StatefulWidget {
  const AddMealScreen({
    super.key,
    required this.categoryId,
    required this.isAddScreen,
    required this.isUpdateScreen,
    this.meal,
  });

  final int categoryId;
  final bool isAddScreen;
  final bool isUpdateScreen;
  final Meal? meal;

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  @override
  Widget build(BuildContext context) {
    MealsProvider mealsProvider =
        Provider.of<MealsProvider>(context, listen: true);
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              MealImageContainer(
                  isAddSource: widget.isAddScreen,
                  isUpdateSource: widget.isUpdateScreen,
                  mealsProvider: mealsProvider,
                  imageUrl: widget.meal?.imageUrl),
              SizeConfig.customSizedBox(null, 20, null),
              CustomAppIconicTextField(
                width: 348,
                height: 37,
                headerText: "meal_name",
                icon: Assets.mealNameIcon,
                controller: MealController().nameController,
                maxLines: 2,
                iconSizeFactor: 31,
                settingsProvider: settingsProvider,
              ),
              settingsProvider.language == 'en'
                  ? Padding(
                      padding: EdgeInsets.only(
                          left: SizeConfig.getProportionalWidth(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: SizeConfig.customSizedBox(
                                31, 31, Image.asset(Assets.mealIngredients)),
                          ),
                          CustomText(
                            isCenter: false,
                            text: TranslationService().translate("ingredients"),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.only(
                          right: SizeConfig.getProportionalWidth(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomText(
                            isCenter: false,
                            text: TranslationService().translate("ingredients"),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: SizeConfig.customSizedBox(
                                31, 31, Image.asset(Assets.mealIngredients)),
                          ),
                        ],
                      ),
                    ),
              SizeConfig.customSizedBox(
                  347,
                  130,
                  Directionality(
                    textDirection: settingsProvider.language == 'ar'
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 0,
                              childAspectRatio: 2),
                      itemCount: mealsProvider.numberOfIngredients,
                      itemBuilder: (context, index) {
                        if (index == mealsProvider.numberOfIngredients - 1) {
                          return AddIngredientBox(
                            mealsProvider: mealsProvider,
                          );
                        }
                        return IngredientBox(
                            settingsProvider: settingsProvider,
                            controller:
                                mealsProvider.ingredientsControllers[index]);
                      },
                    ),
                  )),
              CustomAppIconicTextField(
                width: 348,
                height: 161,
                headerText: "recipe",
                icon: Assets.mealRecipe,
                controller: MealController().recipeController,
                maxLines: 10,
                iconSizeFactor: 48,
                settingsProvider: settingsProvider,
              ),
              SizeConfig.customSizedBox(null, 20, null),
              CustomButton(
                onTap: () async {
                  widget.isAddScreen
                      ? await MealController()
                          .addMeal(mealsProvider, widget.categoryId)
                      : await MealController()
                          .updateMeal(mealsProvider, widget.meal!);
                },
                text: TranslationService()
                    .translate(widget.isAddScreen ? "confirm" : "edit"),
                width: SizeConfig.getProportionalWidth(126),
                height: SizeConfig.getProportionalHeight(45),
              )
            ],
          ),
        ),
      ),
    );
  }
}
