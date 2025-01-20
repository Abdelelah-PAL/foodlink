import 'package:flutter/material.dart';
import 'package:foodlink/core/constants/colors.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/screens/food_screens/add_meal_screen.dart';
import 'package:foodlink/screens/food_screens/meal_screen.dart';
import 'package:foodlink/screens/food_screens/widgets/ingredients_row.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../models/meal.dart';
import '../../../providers/meals_provider.dart';
import '../../../providers/settings_provider.dart';
import 'name_row.dart';

class ListMealTile extends StatefulWidget {
  const ListMealTile({
    super.key,
    required this.meal,
    required this.favorites,
  });

  final Meal meal;
  final bool favorites;

  @override
  State<ListMealTile> createState() => _ListMealTileState();
}

class _ListMealTileState extends State<ListMealTile> {
  onTap() {
    Get.to(MealScreen(meal: widget.meal, source: 'default'));
  }

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: SizeConfig.getProportionalWidth(355),
          height: SizeConfig.getProportionalHeight(95),
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
                width: SizeConfig.getProportionalWidth(182),
                height: SizeConfig.getProportionalHeight(95),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NameRow(
                      name: widget.meal.name,
                      fontSize: 15,
                      textWidth: 100,
                      settingsProvider: settingsProvider,
                      height: 25,
                    ),
                    IngredientsRow(
                      meal: widget.meal,
                      fontSize: 14,
                      textWidth: 80,
                      maxLines: 2,
                      settingsProvider: settingsProvider,
                      height: 35,
                    ),
                    SizeConfig.customSizedBox(null, 10, null),

                    SizeConfig.customSizedBox(
                      null,
                      13,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            !widget.favorites
                                ? GestureDetector(
                                    onTap: () async {
                                      final newIsFavorite =
                                          !widget.meal.isFavorite!;
                                      await MealsProvider().toggleIsFavorite(
                                          widget.meal, newIsFavorite);
                                      setState(() {
                                        widget.meal.isFavorite = newIsFavorite;
                                      });
                                    },
                                    child: widget.meal.isFavorite!
                                        ? const Icon(Icons.favorite,
                                            color: AppColors.errorColor)
                                        : const Icon(Icons.favorite_outline))
                                : const Icon(Icons.favorite,
                                    color: AppColors.errorColor),
                            SizeConfig.customSizedBox(5, null, null),
                            GestureDetector(
                                onTap: () async {
                                  MealsProvider().fillDataForEdition(widget.meal);
                                  Get.to(AddMealScreen(
                                      categoryId: widget.meal.categoryId!,
                                      isAddScreen: false,
                                      meal: widget.meal));
                                },
                                child: const Icon(Icons.edit_outlined)),
                            SizeConfig.customSizedBox(5, null, null),
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
            ],
          )),
    );
  }
}
