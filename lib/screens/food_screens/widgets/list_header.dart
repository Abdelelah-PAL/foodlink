import 'package:flutter/material.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/providers/general_provider.dart';
import 'package:foodlink/screens/food_screens/add_meal_screen.dart';
import 'package:foodlink/screens/widgets/custom_back_button.dart';
import 'package:get/get.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/fonts.dart';

class ListHeader extends StatelessWidget {
  const ListHeader(
      {super.key, required this.text, required this.isEmpty, this.categoryId, required this.favorites});

  final String text;
  final bool isEmpty;
  final int? categoryId;
  final bool favorites;

  @override
  Widget build(BuildContext context) {
    return isEmpty && !favorites
        ? Row(
            children: [
              const CustomBackButton(),
              Expanded(
                child: Center(
                  child: Text(
                    text,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.primaryFont),
                  ),
                ),
              ),
              SizeConfig.customSizedBox(20, null, null),
            ],
          )
        : GeneralProvider().language == 'en'
            ? Padding(
                padding: EdgeInsets.only(
                  top: SizeConfig.getProportionalHeight(10),
                  left: SizeConfig.getProportionalWidth(24),
                  right: SizeConfig.getProportionalWidth(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      text,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFonts.primaryFont),
                    ),
                    SizeConfig.customSizedBox(20, null, null),
                    GestureDetector(
                      onTap: () {
                        Get.to(AddMealScreen(categoryId: categoryId!));
                      },
                      child: Container(
                        width: SizeConfig.getProportionalWidth(30),
                        height: SizeConfig.getProportionalHeight(30),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.widgetsColor),
                        child: const Icon(Icons.add),
                      ),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: EdgeInsets.only(
                  top: SizeConfig.getProportionalHeight(10),
                  left: SizeConfig.getProportionalWidth(24),
                  right: SizeConfig.getProportionalWidth(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(AddMealScreen(categoryId: categoryId!));
                      },
                      child: Container(
                        width: SizeConfig.getProportionalWidth(30),
                        height: SizeConfig.getProportionalHeight(30),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.widgetsColor),
                        child: const Icon(Icons.add),
                      ),
                    ),
                    SizeConfig.customSizedBox(20, null, null),
                    Text(
                      text,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFonts.primaryFont),
                    )
                  ],
                ),
              );
  }
}
