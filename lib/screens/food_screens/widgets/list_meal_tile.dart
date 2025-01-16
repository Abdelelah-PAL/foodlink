import 'package:flutter/material.dart';
import 'package:foodlink/core/constants/colors.dart';
import 'package:foodlink/core/utils/size_config.dart';
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
    return Padding(
        padding: EdgeInsets.only(bottom: SizeConfig.getProportionalHeight(15)),
        child: Stack(
          children: [
            GestureDetector(
              onTap: onTap,
              child: Row(
                textDirection: settingsProvider.language == "en"
                    ? TextDirection.ltr
                    : TextDirection.rtl,
                children: [
                  Expanded(
                      child: Container(
                    width: SizeConfig.getProportionalWidth(182),
                    height: SizeConfig.getProportionalHeight(95),
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1, color: AppColors.defaultBorderColor),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: widget.meal.imageUrl != null &&
                            widget.meal.imageUrl!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            // Apply the same radius here
                            child: Image.network(
                              widget.meal.imageUrl!,
                              fit: BoxFit.fill,
                            ),
                          )
                        : const Icon(Icons.camera_alt_outlined),
                  )),
                  SizeConfig.customSizedBox(10, null, null),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NameRow(
                          name: widget.meal.name,
                          fontSize: 15,
                          textWidth: 115,
                          settingsProvider: settingsProvider,
                        ),
                        SizeConfig.customSizedBox(null, 10, null),
                        IngredientsRow(
                          meal: widget.meal,
                          fontSize: 14,
                          textWidth: 80,
                          maxLines: 3,
                          settingsProvider: settingsProvider,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Positioned(
                left: settingsProvider.language == "en" ? 295 : -12,
                top: 0,
                bottom: -5,
                child: Column(
                  children: [
                    !widget.favorites
                        ? IconButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onPressed: () async {
                              final newIsFavorite = !widget.meal.isFavorite!;
                              await MealsProvider()
                                  .toggleIsFavorite(widget.meal, newIsFavorite);
                              setState(() {
                                widget.meal.isFavorite = newIsFavorite;
                              });
                            },
                            icon: widget.meal.isFavorite!
                                ? const Icon(Icons.favorite,
                                    color: AppColors.errorColor)
                                : const Icon(Icons.favorite_outline))
                        : const Icon(Icons.favorite,
                            color: AppColors.errorColor),
                    IconButton(
                        onPressed: () async {
                          await MealsProvider()
                              .deleteMeal(widget.meal.documentId!);
                          setState(() {
                            MealsProvider().getAllMealsByCategory(
                                widget.meal.categoryId, widget.meal.userId);
                          });
                        },
                        icon: const Icon(Icons.delete)),
                  ],
                ))
          ],
        ));
  }
}
