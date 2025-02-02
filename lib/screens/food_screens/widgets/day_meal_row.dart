import 'package:flutter/material.dart';
import 'package:foodlink/controllers/meal_controller.dart';
import 'package:foodlink/models/meal.dart';
import 'package:foodlink/providers/meals_provider.dart';
import 'package:foodlink/providers/settings_provider.dart';
import 'package:foodlink/screens/widgets/custom_text.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/size_config.dart';
import '../../../services/translation_services.dart';

class DayMealRow extends StatefulWidget {
  const DayMealRow(
      {super.key,
      required this.day,
      required this.month,
      required this.dayName,
      required this.date,
      required this.index,
      required this.settingsProvider,
      required this.mealsProvider,
      this.value});

  final int day;
  final String month;
  final String dayName;
  final DateTime date;
  final int index;
  final SettingsProvider settingsProvider;
  final MealsProvider mealsProvider;
  final String? value;

  @override
  State<DayMealRow> createState() => _DayMealRowState();
}

class _DayMealRowState extends State<DayMealRow> {
  DateTime today = DateTime.now();

  List<Meal> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.mealsProvider.meals.map((meal) => meal).toList();
    if (widget.value != null) {
      widget.mealsProvider.selectedValues[widget.index] = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: widget.settingsProvider.language == 'en'
          ? TextDirection.ltr
          : TextDirection.rtl,
      children: [
        SizeConfig.customSizedBox(
          70,
          null,
          Column(
            children: [
              CustomText(
                  isCenter: true,
                  text: widget.dayName,
                  fontSize: widget.settingsProvider.language == 'en' ? 14 : 20,
                  fontWeight: FontWeight.bold),
              CustomText(
                  isCenter: true,
                  text:
                      '${widget.day.toString()} ${TranslationService().translate(widget.month)}',
                  fontSize: widget.settingsProvider.language == 'en' ? 14 : 20,
                  fontWeight: FontWeight.normal),
            ],
          ),
        ),
        SizeConfig.customSizedBox(10, null, null),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.getProportionalWidth(10)),
          child: IgnorePointer(
            ignoring: widget.date.isBefore(MealController.getPreviousSaturday(
                DateTime(today.year, today.month, today.day))),
            child: GestureDetector(
              onTap: () => {
                _showDropdown(
                    context, widget.mealsProvider.selectedValues[widget.index]),
              },
              child: Container(
                width: SizeConfig.getProportionalWidth(225),
                height: SizeConfig.getProportionalWidth(40),
                decoration: BoxDecoration(
                  color: widget.date.isBefore(
                          MealController.getPreviousSaturday(
                              DateTime(today.year, today.month, today.day)))
                      ? Colors.grey.shade200
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(width: 3.0, color: AppColors.widgetsColor),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    textDirection: widget.settingsProvider.language == 'en'
                        ? TextDirection.ltr
                        : TextDirection.rtl,
                    children: [
                      CustomText(
                        isCenter: false,
                        text:
                            widget
                                    .mealsProvider.selectedValues[widget.index] ?? (widget.date.isBefore(
                                        MealController.getPreviousSaturday(
                                            DateTime(today.year, today.month,
                                                today.day)))
                                    ? ""
                                    : "select_meal"),
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                      if (widget.date.isAfter(
                              MealController.getPreviousSaturday(DateTime(
                                  today.year, today.month, today.day))) ||
                          widget.date.isAtSameMomentAs(
                              MealController.getPreviousSaturday(DateTime(
                                  today.year, today.month, today.day))))
                        const Icon(Icons.keyboard_arrow_down),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  void _showDropdown(BuildContext context, String? selectedValue) {
    _filteredItems = widget.mealsProvider.meals.map((meal) => meal).toList();
    MealController().searchController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: EdgeInsets.all(SizeConfig.getProportionalWidth(20)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.widgetsColor),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.getProportionalWidth(10)),
                    child: TextField(
                      textDirection: widget.settingsProvider.language == 'en'
                          ? TextDirection.ltr
                          : TextDirection.rtl,
                      controller: MealController().searchController,
                      onChanged: _filterItems,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: TranslationService().translate("search"),
                        hintTextDirection:
                            widget.settingsProvider.language == 'en'
                                ? TextDirection.ltr
                                : TextDirection.rtl,
                        prefixIcon: widget.settingsProvider.language == 'en'
                            ? const Icon(Icons.search)
                            : null,
                        icon: widget.settingsProvider.language == 'en'
                            ? null
                            : const Icon(Icons.search),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.getProportionalHeight(300),
                  child: ListView.builder(
                    itemCount: _filteredItems.length,
                    itemBuilder: (ctx, index) {
                      return Column(
                        children: [
                          ListTile(
                            title: CustomText(
                              isCenter: false,
                              text: _filteredItems[index].name,
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: AppColors.fontColor,
                            ),
                            onTap: () {
                              widget.mealsProvider
                                      .selectedValues[widget.index] =
                                  _filteredItems[index].name;
                              widget.mealsProvider.weeklyPlanList.add({
                                _filteredItems[index].documentId!: widget.date
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                          if (index != _filteredItems.length - 1)
                            const Divider(
                              thickness: 1,
                              color: AppColors.defaultBorderColor,
                            )
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _filterItems(String query) {
    setState(() {
      _filteredItems = widget.mealsProvider.meals
          .map((meal) => meal)
          .where(
              (meal) => meal.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }
}
