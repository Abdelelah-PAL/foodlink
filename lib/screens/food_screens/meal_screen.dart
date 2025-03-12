import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../controllers/general_controller.dart';
import '../../controllers/notification_controller.dart';
import '../../controllers/user_types.dart';
import '../../core/constants/colors.dart';
import '../../core/utils/size_config.dart';
import '../../models/meal.dart';
import '../../providers/meals_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/users_provider.dart';
import '../../services/translation_services.dart';
import '../dashboard/dashboard.dart';
import '../widgets/custom_button.dart';
import 'add_meal_screen.dart';
import 'check_ingredients_screen.dart';
import 'meals_list_screen.dart';
import 'widgets/ingredients_row.dart';
import 'widgets/meal_image_container.dart';
import 'widgets/name_row.dart';
import 'widgets/recipe_row.dart';

class MealScreen extends StatelessWidget {
  const MealScreen({super.key, required this.meal, required this.source});

  final Meal meal;
  final String source;

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    MealsProvider mealsProvider =
        Provider.of<MealsProvider>(context, listen: true);
    UsersProvider usersProvider =
        Provider.of<UsersProvider>(context, listen: true);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(bottom: SizeConfig.getProportionalHeight(20)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              MealImageContainer(
                isAddSource: false,
                isUpdateSource: false,
                imageUrl: meal.imageUrl,
                mealsProvider: context.watch<MealsProvider>(),
                backButtonOnPressed: () {
                  switch (source) {
                    case 'default':
                      Get.to(MealsListScreen(
                        index: meal.categoryId! - 1,
                        categoryId: meal.categoryId!,
                      ));
                      break;
                    case 'favorites':
                      Get.to(const Dashboard(initialIndex: 1));
                      break;
                  }
                },
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: SizeConfig.getProportionalWidth(20),
                  right: SizeConfig.getProportionalWidth(20),
                  bottom: SizeConfig.getProportionalHeight(70),
                  top: SizeConfig.getProportionalHeight(20),
                ),
                child: Column(
                  children: [
                    NameRow(
                      name: meal.name,
                      fontSize: 20,
                      textWidth: 280,
                      settingsProvider: settingsProvider,
                      height: 35,
                      maxLines: 2,
                    ),
                    SizeConfig.customSizedBox(null, 15, null),
                    IngredientsRow(
                      meal: meal,
                      fontSize: 20,
                      textWidth: 250,
                      maxLines: 100,
                      settingsProvider: settingsProvider,
                      height: usersProvider.selectedUser!.userTypeId ==
                              UserTypes.cooker
                          ? 100
                          : 150,
                      horizontalPadding: 10,
                      withBorder: true,
                    ),
                    SizeConfig.customSizedBox(null, 20, null),
                    RecipeRow(
                      meal: meal,
                      fontSize: 15,
                      settingsProvider: settingsProvider,
                      usersProvider: usersProvider,
                    )
                  ],
                ),
              ),
              SizeConfig.customSizedBox(null, 50, null),
              usersProvider.selectedUser!.userTypeId == UserTypes.cooker
                  ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      if (source != 'planning') ...[
                        CustomButton(
                          onTap: () {
                            MealsProvider().fillDataForEdition(meal);
                            Get.to(AddMealScreen(
                              categoryId: meal.categoryId!,
                              isUpdateScreen: true,
                              isAddScreen: false,
                              meal: meal,
                              backButtonCallBack: () {
                                Get.to(MealsListScreen(
                                    index: meal.categoryId!,
                                    categoryId: meal.categoryId!));
                                MealsProvider().resetValues();
                              },
                            ));
                          },
                          text: TranslationService().translate("edit"),
                          width: 137,
                          height: 45,
                          isDisabled: true,
                        ),
                        SizeConfig.customSizedBox(20, null, null)
                      ],
                      CustomButton(
                        onTap: () {
                          mealsProvider.checkboxValues = List.generate(
                              meal.ingredients.length, (index) => false);
                          Get.to(CheckIngredientsScreen(
                            meal: meal,
                          ));
                        },
                        text:
                            TranslationService().translate("check_ingredients"),
                        width: 137,
                        height: 45,
                        isDisabled: true,
                      ),
                    ])
                  : CustomButton(
                      onTap: () async {
                        await NotificationController()
                            .addCookerNotification(meal);
                        GeneralController().showCustomDialog(
                            context,
                            settingsProvider,
                            "notification_sent",
                            Icons.check_circle,
                            AppColors.successColor,
                            null);
                      },
                      text: TranslationService().translate("request_meal"),
                      width: 150,
                      height: 45,
                      isDisabled: true,
                    )
            ],
          ),
        ),
      ),
    );
  }
}
