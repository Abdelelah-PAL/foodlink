import 'package:flutter/material.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/screens/food_screens/add_meal_screen.dart';
import 'package:foodlink/screens/widgets/custom_back_button.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../providers/settings_provider.dart';

class ListHeader extends StatelessWidget {
  const ListHeader(
      {super.key, required this.text, required this.isEmpty, this.categoryId, required this.favorites});

  final String text;
  final bool isEmpty;
  final int? categoryId;
  final bool favorites;

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
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
        : settingsProvider.language == 'en'
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
                    if(!favorites)
                      GestureDetector(
                      onTap: () {
                        Get.to(AddMealScreen(categoryId: categoryId!, isAddScreen: true,));
                      },
                      child:  Container(
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
                    if(!favorites)
                      GestureDetector(
                      onTap: () {
                        Get.to(AddMealScreen(categoryId: categoryId!, isAddScreen: true,));
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
