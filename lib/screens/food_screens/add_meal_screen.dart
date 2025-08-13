import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/meal_controller.dart';
import '../../core/constants/assets.dart';
import '../../core/utils/size_config.dart';
import '../../models/meal.dart';
import '../../providers/meals_provider.dart';
import '../../providers/settings_provider.dart';
import '../../services/translation_services.dart';
import '../widgets/custom_app_iconic_textfield.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';
import 'widgets/ingredient_box.dart';
import 'widgets/meal_image_container.dart';
import 'widgets/step_box.dart';

class AddMealScreen extends StatefulWidget {
  const AddMealScreen({
    super.key,
    required this.categoryId,
    required this.isAddScreen,
    required this.isUpdateScreen,
    this.meal,
    required this.backButtonCallBack,
  });

  final int categoryId;
  final bool isAddScreen;
  final bool isUpdateScreen;
  final Meal? meal;
  final VoidCallback backButtonCallBack;

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
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: mealsProvider.isLoading == true
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: SizeConfig.getProportionalHeight(42)),
                    child: Column(
                      children: [
                        MealImageContainer(
                          isAddSource: widget.isAddScreen,
                          isUpdateSource: widget.isUpdateScreen,
                          mealsProvider: mealsProvider,
                          imageUrl: widget.meal?.imageUrl,
                          backButtonOnPressed: widget.backButtonCallBack,
                        ),
                        SizeConfig.customSizedBox(null, 20, null),
                        CustomAppIconicTextField(
                          width: 348,
                          height: 40,
                          headerText: "meal_name",
                          icon: Assets.mealNameIcon,
                          controller: MealController().nameController,
                          maxLines: 2,
                          iconSizeFactor: 28,
                          settingsProvider: settingsProvider,
                          iconPadding: 26,
                          enabled: true,
                        ),
                        SizeConfig.customSizedBox(null, 20, null),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.getProportionalWidth(26),
                          ),
                          child: Row(
                            textDirection: settingsProvider.language == 'en'
                                ? TextDirection.ltr
                                : TextDirection.rtl,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizeConfig.customSizedBox(
                                  31, 31, Image.asset(Assets.mealIngredients)),
                              CustomText(
                                isCenter: false,
                                text: TranslationService()
                                    .translate("ingredients"),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ),
                        Container(
                            width: SizeConfig.getProportionalWidth(347),
                            height: SizeConfig.getProportionalHeight(130),
                            margin: EdgeInsets.symmetric(
                                horizontal:
                                    SizeConfig.getProportionalWidth(26)),
                            child: Directionality(
                              textDirection: settingsProvider.language == 'ar'
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 8,
                                        mainAxisSpacing: 0,
                                        childAspectRatio: 1.7),
                                itemCount: mealsProvider.numberOfIngredients,
                                itemBuilder: (context, index) {
                                  if (index ==
                                      mealsProvider.numberOfIngredients - 1) {
                                    return AddIngredientBox(
                                      mealsProvider: mealsProvider,
                                    );
                                  }
                                  return IngredientBox(
                                    settingsProvider: settingsProvider,
                                    controller: mealsProvider
                                        .ingredientsControllers[index],
                                    mealsProvider: mealsProvider,
                                    index: index,
                                  );
                                },
                              ),
                            )),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.getProportionalWidth(26),
                          ),
                          child: Row(
                            textDirection: settingsProvider.language == 'en'
                                ? TextDirection.ltr
                                : TextDirection.rtl,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizeConfig.customSizedBox(
                                  31, 31, Image.asset(Assets.mealRecipe)),
                              CustomText(
                                isCenter: false,
                                text: TranslationService().translate("recipe"),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ),
                        Container(
                            width: SizeConfig.getProportionalWidth(347),
                            height: SizeConfig.getProportionalHeight(150),
                            margin: EdgeInsets.symmetric(
                                horizontal:
                                    SizeConfig.getProportionalWidth(26)),
                            child: ListView.builder(
                              itemCount: mealsProvider.numberOfSteps,
                              itemBuilder: (context, index) {
                                if (index == mealsProvider.numberOfSteps - 1) {
                                  return AddStepBox(
                                    mealsProvider: mealsProvider,
                                  );
                                }
                                return StepBox(
                                  settingsProvider: settingsProvider,
                                  controller:
                                      mealsProvider.stepsControllers[index],
                                  mealsProvider: mealsProvider,
                                  index: index,
                                );
                              },
                            )),
                        SizeConfig.customSizedBox(null, 20, null),
                        CustomAppIconicTextField(
                          width: 348,
                          height: 37,
                          headerText: "source",
                          icon: Assets.mealSource,
                          controller: MealController().sourceController,
                          maxLines: 2,
                          iconSizeFactor: 28,
                          settingsProvider: settingsProvider,
                          iconPadding: 26,
                          enabled: true,
                          textAlign: TextAlign.left,
                        ),
                        SizeConfig.customSizedBox(null, 20, null),
                        CustomButton(
                          onTap: () async {
                            mealsProvider.setLoading();
                            widget.isAddScreen
                                ? await MealController()
                                    .addMeal(mealsProvider, widget.categoryId)
                                : await MealController()
                                    .updateMeal(mealsProvider, widget.meal!);
                            mealsProvider.resetLoading();
                          },
                          text: TranslationService().translate(
                              widget.isAddScreen ? "confirm" : "edit"),
                          width: SizeConfig.getProportionalWidth(126),
                          height: SizeConfig.getProportionalHeight(45),
                          isDisabled: true,
                        )
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
