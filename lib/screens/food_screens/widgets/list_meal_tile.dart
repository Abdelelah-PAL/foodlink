import 'package:flutter/material.dart';
import 'package:foodlink/core/constants/colors.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/providers/general_provider.dart';
import 'package:foodlink/screens/food_screens/meal_screen.dart';
import 'package:foodlink/screens/food_screens/widgets/ingredients_row.dart';
import 'package:get/get.dart';
import '../../../models/meal.dart';
import '../../../providers/meals_provider.dart';
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
    Get.to(MealScreen(meal: widget.meal));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: SizeConfig.getProportionalHeight(15)),
      child: GeneralProvider().language == "en"
          ? Stack(
              children: [
                GestureDetector(
                  onTap: onTap,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                            width: SizeConfig.getProportionalWidth(182),
                            height: SizeConfig.getProportionalHeight(95),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1,
                                  color: AppColors.defaultBorderColor),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Image.asset(
                              widget.meal.imageUrl!,
                              fit: BoxFit.fill,
                            )),
                      ),
                      SizeConfig.customSizedBox(10, null, null),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            NameRow(
                              meal: widget.meal,
                              fontSize: 15,
                              textWidth: 115,
                            ),
                            SizeConfig.customSizedBox(null, 10, null),
                            IngredientsRow(
                              meal: widget.meal,
                              fontSize: 14,
                              textWidth: 115,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: widget.favorites
                      ? IconButton(
                      onPressed: () async {
                        final newIsFavorite = !widget.meal.isFavorite;

                        await MealsProvider()
                            .toggleIsFavorite(widget.meal, newIsFavorite);
                        setState(() {
                          widget.meal.isFavorite = newIsFavorite;
                        });
                      },
                      icon: widget.meal.isFavorite
                          ? const Icon(Icons.favorite)
                          : const Icon(Icons.favorite_outline))
                      : const Icon(Icons.favorite_outline),
                )
              ],
            )
          : Stack(
              children: [
                GestureDetector(
                  onTap: onTap,
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          NameRow(
                              meal: widget.meal, fontSize: 15, textWidth: 115),
                          SizeConfig.customSizedBox(null, 10, null),
                          IngredientsRow(
                              meal: widget.meal, fontSize: 14, textWidth: 115),
                        ],
                      ),
                      SizeConfig.customSizedBox(10, null, null),
                      Expanded(
                          child: Container(
                        width: SizeConfig.getProportionalWidth(182),
                        height: SizeConfig.getProportionalHeight(95),
                        decoration: BoxDecoration(
                          color: AppColors.widgetsColor,
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
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: widget.favorites
                      ? IconButton(
                          onPressed: () async {
                            final newIsFavorite = !widget.meal.isFavorite;

                            await MealsProvider()
                                .toggleIsFavorite(widget.meal, newIsFavorite);
                            setState(() {
                              widget.meal.isFavorite = newIsFavorite;
                            });
                          },
                          icon: widget.meal.isFavorite
                              ? const Icon(Icons.favorite)
                              : const Icon(Icons.favorite_outline))
                      : const Icon(Icons.favorite_outline),
                )
              ],
            ),
    );
  }
}
