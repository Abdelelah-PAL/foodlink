import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../controllers/meal_controller.dart';
import '../../controllers/notification_controller.dart';
import '../../core/constants/assets.dart';
import '../../core/utils/size_config.dart';
import '../../models/meal.dart';
import '../../providers/meals_provider.dart';
import '../../providers/settings_provider.dart';
import '../../services/translation_services.dart';
import '../widgets/custom_app_iconic_textfield.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';
import 'widgets/checkbox_tile.dart';
import 'widgets/meal_image_container.dart';
import 'widgets/name_row.dart';

class CheckIngredientsScreen extends StatelessWidget {
  const CheckIngredientsScreen({super.key, required this.meal});

  final Meal meal;

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    MealsProvider mealsProvider =
        Provider.of<MealsProvider>(context, listen: true);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            crossAxisAlignment: settingsProvider.language == "en"
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: [
              MealImageContainer(
                isAddSource: false,
                isUpdateSource: false,
                imageUrl: meal.imageUrl,
                mealsProvider: context.watch<MealsProvider>(),
                backButtonOnPressed: () {
                  MealController().missingIngredients.clear();
                  NotificationController().addNoteController.clear();
                  Get.back();
                },
              ),
              NameRow(
                name: meal.name,
                fontSize: 20,
                textWidth: 280,
                settingsProvider: settingsProvider,
                height: 35,
                maxLines: 2,
                horizontalPadding: 23,
              ),
              SizeConfig.customSizedBox(null, 10, null),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.getProportionalWidth(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textDirection: settingsProvider.language == 'en'
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                  children: [
                    Image.asset(Assets.mealIngredients),
                    SizeConfig.customSizedBox(10, null, null),
                    const CustomText(
                        isCenter: false,
                        text: "ingredients",
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.getProportionalWidth(20)),
                child: SizeConfig.customSizedBox(
                  null,
                  250,
                  ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: meal.ingredients.length,
                    itemBuilder: (ctx, index) {
                      return CheckboxTile(
                          text: meal.ingredients[index],
                          settingsProvider: settingsProvider,
                          mealsProvider: mealsProvider,
                          index: index,
                          ingredientsLength: meal.ingredients.length);
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.getProportionalWidth(20)),
                child: CustomAppIconicTextField(
                  width: 263,
                  height: 79,
                  headerText: "add_notes",
                  icon: Assets.note,
                  controller: NotificationController().addNoteController,
                  maxLines: 7,
                  iconSizeFactor: 31,
                  settingsProvider: settingsProvider,
                  iconPadding: 0,
                  enabled: true,
                ),
              ),
              SizeConfig.customSizedBox(null, 30, null),
              Padding(
                padding: EdgeInsets.only(
                    bottom: SizeConfig.getProportionalWidth(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  textDirection: settingsProvider.language == 'en'
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                  children: [
                    CustomButton(
                      onTap: () {
                        NotificationController().addUserNotification(
                            meal, settingsProvider, context);
                      },
                      text: TranslationService().translate("notify"),
                      width: 137,
                      height: 45,
                      isDisabled: true,
                    ),
                    SizeConfig.customSizedBox(20, null, null),
                    CustomButton(
                      onTap: () => {
                        MealController().missingIngredients.clear(),
                        NotificationController().addNoteController.clear(),
                        Get.back()
                      },
                      text: TranslationService().translate("back"),
                      width: 137,
                      height: 45,
                      isDisabled: true,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
