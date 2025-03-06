import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../controllers/meal_controller.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/size_config.dart';
import '../../../models/meal.dart';
import '../../../providers/meals_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../services/translation_services.dart';
import '../../widgets/custom_text.dart';

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
  List<Meal> _filteredItems = [];

  @override
  void initState() {
    super.initState();

    if (widget.value != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.mealsProvider.resetShowSelectedValue(widget.index);
      });
    }

    _filteredItems = widget.mealsProvider.meals.map((meal) => meal).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: widget.settingsProvider.language == 'en'
          ? TextDirection.ltr
          : TextDirection.rtl,
      children: [
        SizeConfig.customSizedBox(
          90,
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
                DateTime(
                    widget.mealsProvider.today.year,
                    widget.mealsProvider.today.month,
                    widget.mealsProvider.today.day))),
            child: GestureDetector(
              onTap: () => {
                _showDropdown(
                    context, widget.mealsProvider.selectedValues[widget.index]),
              },
              child: Container(
                width: SizeConfig.getProportionalWidth(180),
                height: SizeConfig.getProportionalWidth(40),
                decoration: BoxDecoration(
                  color: widget.date.isBefore(
                          MealController.getPreviousSaturday(DateTime(
                              widget.mealsProvider.today.year,
                              widget.mealsProvider.today.month,
                              widget.mealsProvider.today.day)))
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
                      Expanded(
                        child: CustomText(
                          isCenter: false,
                          text: widget.date.isBefore(
                                  MealController.getPreviousSaturday(DateTime(
                                      widget.mealsProvider.today.year,
                                      widget.mealsProvider.today.month,
                                      widget.mealsProvider.today.day)))
                              ? widget.value ?? ""
                              : widget.mealsProvider
                                          .showSelectedValues[widget.index] ==
                                      true
                                  ? widget.mealsProvider
                                          .selectedValues[widget.index] ??
                                      "select_meal"
                                  : widget.value ?? "select_meal",
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      if (widget.date.isAfter(
                              MealController.getPreviousSaturday(DateTime(
                                  widget.mealsProvider.today.year,
                                  widget.mealsProvider.today.month,
                                  widget.mealsProvider.today.day))) ||
                          widget.date.isAtSameMomentAs(
                              MealController.getPreviousSaturday(DateTime(
                                  widget.mealsProvider.today.year,
                                  widget.mealsProvider.today.month,
                                  widget.mealsProvider.today.day))))
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
                    itemCount: _filteredItems.length + 1,
                    itemBuilder: (ctx, index) {
                      return Column(
                        children: [
                          if (index == 0)
                            ListTile(
                              title: const CustomText(
                                isCenter: false,
                                text: 'select_meal',
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: AppColors.fontColor,
                              ),
                              onTap: () {
                                widget.mealsProvider
                                        .selectedValues[widget.index] =
                                    TranslationService()
                                        .translate('select_meal');
                                widget.mealsProvider.weeklyPlanList.removeWhere(
                                  (record) {
                                    Timestamp dateTimestamp =
                                        Timestamp.fromDate(widget.date);
                                    return record.containsValue(dateTimestamp);
                                  },
                                );
                                widget.mealsProvider
                                    .setShowSelectedValue(widget.index);
                                Navigator.of(context).pop();
                              },
                            )
                          else
                            ListTile(
                              title: CustomText(
                                isCenter: false,
                                text: _filteredItems[index - 1].name,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColors.fontColor,
                                maxLines: 1,
                              ),
                              onTap: () {
                                Timestamp dateTimestamp =
                                    Timestamp.fromDate(widget.date);
                                widget.mealsProvider
                                        .selectedValues[widget.index] =
                                    _filteredItems[index - 1].name;
                                widget.mealsProvider.weeklyPlanList.removeWhere(
                                  (record) {
                                    return record.containsValue(dateTimestamp);
                                  },
                                );
                                widget.mealsProvider.weeklyPlanList.add({
                                  _filteredItems[index - 1].documentId!:
                                      dateTimestamp
                                });
                                widget.mealsProvider
                                    .setShowSelectedValue(widget.index);
                                Navigator.of(context).pop();
                              },
                            ),
                          if (index != _filteredItems.length)
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
