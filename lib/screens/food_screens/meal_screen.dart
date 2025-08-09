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
import 'widgets/ingredients_meal_view.dart';
import 'widgets/meal_image_container.dart';
import 'widgets/name_row.dart';
import 'widgets/recipe_meal_view.dart';
import 'widgets/source_meal_view.dart';

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
        padding: EdgeInsets.only(bottom: SizeConfig.getProportionalHeight(30)),
        child: SingleChildScrollView(
          child: Expanded(
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
                      default:
                        Get.back();
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
                    crossAxisAlignment: settingsProvider.language == 'en'
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end,
                    children: [
                      NameRow(
                        name: meal.name,
                        fontSize: 20,
                        textWidth: 280,
                        settingsProvider: settingsProvider,
                        height: 35,
                        maxLines: 2,
                        horizontalPadding: 30,
                      ),
                      SizeConfig.customSizedBox(null, 30, null),
                      IngredientsMealView(
                        meal: meal,
                        settingsProvider: settingsProvider,
                        usersProvider: usersProvider,
                      ),
                      SizeConfig.customSizedBox(null, 30, null),
                      RecipeMealView(
                        meal: meal,
                        fontSize: 15,
                        settingsProvider: settingsProvider,
                        usersProvider: usersProvider,
                      ),
                      SizeConfig.customSizedBox(null, 30, null),
                      SourceMealView(
                          meal: meal,
                          settingsProvider: settingsProvider,
                          usersProvider: usersProvider)
                    ],
                  ),
                ),
                usersProvider.selectedUser!.userTypeId == UserTypes.cooker
                    ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        if (meal.isPlanned == false) ...[
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
      ),
    );
  }
}
