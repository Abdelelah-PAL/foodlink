import 'package:flutter/material.dart';
import 'package:foodlink/core/constants/colors.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/providers/general_provider.dart';
import 'package:foodlink/screens/food_screens/meal_screen.dart';
import 'package:foodlink/screens/food_screens/widgets/ingredients_row.dart';
import 'package:get/get.dart';
import '../../../models/meal.dart';
import 'name_row.dart';

class ListMealTile extends StatelessWidget {
  const ListMealTile({
    super.key,
    required this.meal,
  });

  final Meal meal;

  onTap() {
    Get.to(MealScreen(meal: meal));
  }

  @override
  Widget build(BuildContext context) {
    return GeneralProvider().language == "en"
        ? GestureDetector(
            onTap: onTap,
            child: Stack(
              children: [
                Row(
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
                          child: Image.asset(
                            meal.imageUrl!,
                            fit: BoxFit.fill,
                          )),
                    ),
                    SizeConfig.customSizedBox(10, null, null),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NameRow(meal: meal, fontSize: 15, textWidth: 115,),
                          SizeConfig.customSizedBox(null, 10, null),
                          IngredientsRow(meal: meal, fontSize: 14, textWidth: 115,),
                        ],
                      ),
                    )
                  ],
                ),
                const Positioned(
                  right: 0,
                  bottom: 0,
                  child: Icon(Icons.favorite_outline),
                )
              ],
            ),
          )
        : GestureDetector(
            onTap: onTap,
            child: Stack(
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        NameRow(meal: meal, fontSize: 15, textWidth: 115),
                        SizeConfig.customSizedBox(null, 10, null),
                        IngredientsRow(meal: meal, fontSize: 14, textWidth: 115),
                      ],
                    ),
                    SizeConfig.customSizedBox(10, null, null),
                    Expanded(
                      child: Container(
                          width: SizeConfig.getProportionalWidth(182),
                          height: SizeConfig.getProportionalHeight(95),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1, color: AppColors.defaultBorderColor),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Image.network(
                            meal.imageUrl!,
                            fit: BoxFit.fill,
                          )),
                    ),
                  ],
                ),
                const Positioned(
                  left: 0,
                  bottom: 0,
                  child: Icon(Icons.favorite_outline),
                )
              ],
            ),
          );
  }
}
