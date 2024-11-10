import 'package:flutter/material.dart';
import 'package:foodlink/core/constants/assets.dart';
import 'package:foodlink/core/constants/colors.dart';
import 'package:foodlink/core/constants/fonts.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/providers/general_provider.dart';
import '../../../models/meal.dart';

class ListMealTile extends StatelessWidget {
  const ListMealTile({
    super.key,
    required this.meal,
  });

  final Meal meal;

  @override
  Widget build(BuildContext context) {
    return GeneralProvider().language == "en"
        ? Stack(
          children: [
            Row(
                children: [
                  Container(
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
                  SizedBox(
                    width: SizeConfig.getProportionalWidth(10),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset(Assets.mealNameIcon),
                          SizedBox(
                            width: SizeConfig.getProportionalWidth(10),
                          ),
                          Text(
                            meal.name,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: AppFonts.primaryFont
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.getProportionalHeight(10),
                      ),
                      Row(
                        children: [
                          Image.asset(Assets.mealIngredients),
                          SizedBox(
                            width: SizeConfig.getProportionalWidth(10),
                          ),
                          Text(
                            meal.ingredients,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: AppFonts.primaryFont
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            const Positioned(
              right: 100,
              bottom: 0,
              child: Icon(Icons.favorite_outline),
            )
          ],
        )
        : Stack(
          children: [
            Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Text(
                            meal.name,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: AppFonts.primaryFont
                            ),
                          ),
                          SizedBox(
                            width: SizeConfig.getProportionalWidth(10),
                          ),
                          Image.asset(Assets.mealNameIcon),
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.getProportionalHeight(10),
                      ),
                      Row(
                        children: [
                          Text(
                            meal.ingredients,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: AppFonts.primaryFont
                            ),
                          ),
                          SizedBox(
                            width: SizeConfig.getProportionalWidth(10),
                          ),
                          Image.asset(Assets.mealIngredients),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: SizeConfig.getProportionalWidth(10),
                  ),
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
                ],
              ),
            const Positioned(
              left: 0,
              bottom: 0,
              child: Icon(Icons.favorite_outline),
            )
          ],
        );
  }
}
