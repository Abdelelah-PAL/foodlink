import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../controllers/user_types.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/size_config.dart';
import '../../../models/meal.dart';
import '../../../providers/meals_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../providers/users_provider.dart';
import '../add_meal_screen.dart';
import '../meal_screen.dart';
import '../meals_list_screen.dart';
import 'ingredients_row.dart';
import 'name_row.dart';

class ListMealTile extends StatefulWidget {
  const ListMealTile({
    super.key,
    required this.meal,
    required this.favorites,
    required this.source,
  });

  final Meal meal;
  final bool favorites;
  final String source;

  @override
  State<ListMealTile> createState() => _ListMealTileState();
}

class _ListMealTileState extends State<ListMealTile> {
  onTap() {
    Get.to(MealScreen(meal: widget.meal, source: widget.source));
  }

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    UsersProvider usersProvider = Provider.of<UsersProvider>(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: SizeConfig.getProportionalWidth(355),
          height: SizeConfig.getProportionalHeight(110),
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 7,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            textDirection: settingsProvider.language == "en"
                ? TextDirection.ltr
                : TextDirection.rtl,
            children: [
              Container(
                width: SizeConfig.getProportionalWidth(150),
                height: SizeConfig.getProportionalHeight(110),
                margin: EdgeInsets.only(
                    left: settingsProvider.language == 'en'
                        ? 0
                        : SizeConfig.getProportionalWidth(0),
                    right: settingsProvider.language == 'en'
                        ? SizeConfig.getProportionalWidth(0)
                        : 0),
                decoration: const BoxDecoration(
                  color: AppColors.widgetsColor,
                ),
                child: widget.meal.imageUrl != null &&
                        widget.meal.imageUrl!.isNotEmpty
                    ? Image.network(
                        widget.meal.imageUrl!,
                        fit: BoxFit.fill,
                      )
                    : const Icon(Icons.camera_alt_outlined),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      left: settingsProvider.language == 'en'
                          ? 0
                          : SizeConfig.getProportionalWidth(5),
                      right: settingsProvider.language == 'en'
                          ? SizeConfig.getProportionalWidth(5)
                          : 0),
                  child: Column(
                    children: [
                      NameRow(
                        name: widget.meal.name,
                        fontSize: 15,
                        textWidth: 135,
                        settingsProvider: settingsProvider,
                        height: 25,
                        maxLines: 1,
                        horizontalPadding: 10,
                      ),
                      IngredientsRow(
                        meal: widget.meal,
                        fontSize: 14,
                        textWidth: 135,
                        maxLines: 2,
                        settingsProvider: settingsProvider,
                        height: 50,
                        horizontalPadding: 8,
                        withBorder: false,
                      ),
                      SizeConfig.customSizedBox(null, 10, null),
                      SizeConfig.customSizedBox(
                        null,
                        13,
                        Padding(
                          padding: EdgeInsets.only(
                            top: SizeConfig.getProportionalHeight(0),
                          ),
                          child: Row(
                            mainAxisAlignment: settingsProvider.language == "en"
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              !widget.favorites
                                  ? GestureDetector(
                                      onTap: () async {
                                        final newIsFavorite =
                                            !widget.meal.isFavorite!;
                                        await MealsProvider().toggleIsFavorite(
                                            widget.meal, newIsFavorite);
                                        setState(() {
                                          widget.meal.isFavorite =
                                              newIsFavorite;
                                        });
                                      },
                                      child: widget.meal.isFavorite!
                                          ? const Icon(Icons.favorite,
                                              color: AppColors.errorColor)
                                          : const Icon(Icons.favorite_outline))
                                  : const Icon(Icons.favorite,
                                      color: AppColors.errorColor),
                              SizeConfig.customSizedBox(5, null, null),
                              if (usersProvider.selectedUser!.userTypeId ==
                                  UserTypes.cooker) ...[
                                GestureDetector(
                                    onTap: () async {
                                      MealsProvider()
                                          .fillDataForEdition(widget.meal);
                                      Get.to(AddMealScreen(
                                          categoryId: widget.meal.categoryId!,
                                          isAddScreen: false,
                                          meal: widget.meal,
                                          isUpdateScreen: true,
                                          backButtonCallBack: () {
                                            Get.to(MealsListScreen(
                                                index: widget.meal.categoryId!,
                                                categoryId:
                                                    widget.meal.categoryId!));
                                            MealsProvider().resetValues();
                                          }));
                                    },
                                    child: const Icon(Icons.edit_outlined)),
                                SizeConfig.customSizedBox(5, null, null)
                              ],
                              GestureDetector(
                                  onTap: () async {
                                    await MealsProvider()
                                        .deleteMeal(widget.meal.documentId!);
                                    setState(() {
                                      MealsProvider().getAllMealsByCategory(
                                          widget.meal.categoryId,
                                          widget.meal.userId);
                                    });
                                  },
                                  child: const Icon(Icons.delete_outlined)),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
