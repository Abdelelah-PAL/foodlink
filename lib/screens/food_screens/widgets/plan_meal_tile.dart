import 'package:flutter/material.dart';
import 'package:foodlink/providers/meals_provider.dart';
import 'package:foodlink/providers/settings_provider.dart';
import 'package:foodlink/screens/food_screens/meal_screen.dart';
import 'package:foodlink/screens/widgets/custom_text.dart';
import 'package:foodlink/services/translation_services.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import '../../../../models/meal.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/size_config.dart';
import 'ingredients_row.dart';
import 'name_row.dart';

class PlanMealTile extends StatefulWidget {
  const PlanMealTile({
    super.key,
    required this.meal,
    required this.day,
    required this.date,
    required this.index,
    required this.mealsProvider,
    required this.settingsProvider,
  });

  final Meal meal;
  final String day;
  final DateTime date;
  final int index;
  final MealsProvider mealsProvider;
  final SettingsProvider settingsProvider;

  @override
  State<PlanMealTile> createState() => _PlanMealTileState();
}

class _PlanMealTileState extends State<PlanMealTile> {
  late String formattedDate;

  onTap() {
    Get.to(MealScreen(
      meal: widget.meal,
      source: 'planning',
    ));
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ar_SA', null).then((_) {
      setState(() {
        formattedDate =
            intl.DateFormat.yMMMMd('ar_SA').format(widget.meal.date!);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider =
        Provider.of<SettingsProvider>(context, listen: true);

    String formattedDate = settingsProvider.language == "en"
        ? intl.DateFormat.yMMMMd('en_US')
            .format(widget.mealsProvider.plannedMeals[widget.index].date!)
        : intl.DateFormat.yMMMMd('ar_SA')
            .format(widget.mealsProvider.plannedMeals[widget.index].date!);

    return Column(children: [
      Row(
        textDirection: SettingsProvider().language == "en"
            ? TextDirection.ltr
            : TextDirection.rtl,
        children: [
          SizeConfig.customSizedBox(
            80,
            null,
            CustomText(
                isCenter: false,
                text: TranslationService().translate(widget.day),
                fontSize: SettingsProvider().language == "en" ? 12 : 20,
                fontWeight: FontWeight.bold),
          ),
          SizeConfig.customSizedBox(
            120,
            null,
            CustomText(
                isCenter: false,
                text: formattedDate,
                fontSize: SettingsProvider().language == "en" ? 10 : 18,
                fontWeight: FontWeight.normal),
          )
        ],
      ),
      Padding(
          padding:
              EdgeInsets.only(bottom: SizeConfig.getProportionalHeight(15)),
          child: Stack(
            children: [
              GestureDetector(
                onTap: onTap,
                child: Row(
                  textDirection: widget.settingsProvider.language == "en"
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
                              child: Image.network(
                                widget.meal.imageUrl!,
                                fit: BoxFit.fill,
                              ),
                            )
                          : const Icon(Icons.camera_alt_outlined),
                    )
                    ),
                    SizeConfig.customSizedBox(10, null, null),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NameRow(
                            name: widget.meal.name,
                            fontSize: 15,
                            textWidth: 115,
                            settingsProvider: widget.settingsProvider,
                            height: 35,
                          ),
                          SizeConfig.customSizedBox(null, 10, null),
                          IngredientsRow(
                            meal: widget.meal,
                            fontSize: 14,
                            textWidth: 115,
                            maxLines: 3,
                            settingsProvider: widget.settingsProvider,
                            height: 50,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          )),
    ]);
  }
}
