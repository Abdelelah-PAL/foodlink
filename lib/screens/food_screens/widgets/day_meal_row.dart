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
  const DayMealRow({
    super.key,
    required this.day,
    required this.month,
    required this.dayName,
    required this.index,
    required this.settingsProvider,
    required this.mealsProvider,
  });

  final int day;
  final String month;
  final String dayName;
  final int index;
  final SettingsProvider settingsProvider;
  final MealsProvider mealsProvider;

  @override
  State<DayMealRow> createState() => _DayMealRowState();
}

class _DayMealRowState extends State<DayMealRow> {
  List<String> _filteredItems = [];
  String? selectedValue;

  @override
  void initState() {
    _filteredItems =
        widget.mealsProvider.meals.map((meal) => meal.name).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: widget.settingsProvider.language == 'en'
          ? TextDirection.ltr
          : TextDirection.rtl,
      children: [
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
        SizeConfig.customSizedBox(10, null, null),
        Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.getProportionalWidth(10)),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => _showDropdown(context),
                  child: Container(
                    width: SizeConfig.getProportionalWidth(245),
                    height: SizeConfig.getProportionalWidth(40),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(width: 3.0, color: Colors.yellow),
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
                            text: selectedValue ?? "select_meal",
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                          const Icon(Icons.keyboard_arrow_down),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )

            // DropdownButton<String>(
            //   menuWidth: SizeConfig.getProportionalWidth(245),
            //   borderRadius: BorderRadius.circular(15),
            //   dropdownColor: AppColors.backgroundColor,
            //   padding: EdgeInsets.symmetric(
            //       horizontal: SizeConfig.getProportionalWidth(10)),
            //   alignment: widget.settingsProvider.language == "en"
            //       ? Alignment.centerLeft
            //       : Alignment.centerRight,
            //   value: selectedValue,
            //   icon: const Icon(
            //     Icons.keyboard_arrow_down,
            //     size: 24,
            //     color: Colors.black,
            //   ),
            //   hint: const CustomText(
            //     isCenter: false,
            //     text: "select_meal",
            //     fontSize: 18,
            //     fontWeight: FontWeight.w400,
            //   ),
            //   style: const TextStyle(color: Colors.black, fontSize: 16),
            //   underline: const SizedBox(),
            //   isExpanded: true,
            //   onChanged: (String? newValue) {
            //     setState(() {
            //       selectedValue = newValue;
            //     });
            //   },
            //   items: [
            //     DropdownMenuItem<String>(
            //       value: "select_meal",
            //       child: Align(
            //         alignment: widget.settingsProvider.language == 'en'
            //             ? Alignment.centerLeft
            //             : Alignment.centerRight,
            //         child: const CustomText(
            //           isCenter: false,
            //           text: "select_meal",
            //           fontSize: 15,
            //           fontWeight: FontWeight.w400,
            //         ),
            //       ),
            //     ),
            //     ...widget.mealsProvider.meals
            //         .map<DropdownMenuItem<String>>((Meal meal) {
            //       return DropdownMenuItem<String>(
            //         value: meal.name,
            //         child: Align(
            //           alignment: widget.settingsProvider.language == "en"
            //               ? Alignment.centerLeft
            //               : Alignment.centerRight,
            //           child: CustomText(
            //             isCenter: false,
            //             text: meal.name,
            //             fontSize: 15,
            //             fontWeight: FontWeight.w400,
            //           ),
            //         ),
            //       );
            //     })
            //   ],
            // )),
            )
      ],
    );
  }

  void _showDropdown(BuildContext context) {
    _filteredItems =
        widget.mealsProvider.meals.map((meal) => meal.name).toList();
    MealController().searchController.clear();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
              top: SizeConfig.getProportionalHeight(50),
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:  EdgeInsets.symmetric(
                    horizontal: SizeConfig.getProportionalWidth(20),
                    vertical: SizeConfig.getProportionalWidth(20)
                ),
                child: TextField(
                  textDirection: widget.settingsProvider.language == 'en'
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                  controller: MealController().searchController,
                  onChanged: _filterItems,
                  decoration: InputDecoration(
                    hintText: TranslationService().translate("search"),
                    hintTextDirection: widget.settingsProvider.language == 'en'
                        ? TextDirection.ltr
                        : TextDirection.rtl,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _filteredItems.length,
                  itemBuilder: (ctx, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.getProportionalWidth(10)),
                      child: ListTile(
                        title: CustomText(
                          isCenter: false,
                          text: _filteredItems[index],
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: AppColors.fontColor,
                        ),
                        onTap: () {
                          onChanged(_filteredItems[index]);
                          Navigator.of(context).pop();
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget listContainer() {
    return Container(
      width: SizeConfig.getProportionalWidth(240),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.widgetsColor,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListView.builder(
        itemCount: widget.mealsProvider.meals.length + 1,
        scrollDirection: Axis.vertical,
        itemBuilder: (ctx, index) {
          Meal meal = widget.mealsProvider.meals[index];
          if (index == 0) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              textDirection: widget.settingsProvider.language == 'en'
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              children: const [
                CustomText(
                  isCenter: false,
                  text: 'search',
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: AppColors.hintTextColor,
                ),
                Icon(Icons.search)
              ],
            );
          } else {
            return Column(
              children: [
                CustomText(
                    isCenter: false,
                    text: meal.name,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
                const Divider(
                  thickness: 1,
                  color: Colors.grey,
                )
              ],
            );
          }
        },
      ),
    );
  }

  void _filterItems(String query) {
    setState(() {
      _filteredItems = _filteredItems
          .where((mealName) =>
              mealName.toLowerCase().contains(query.toLowerCase()))
          .toList();
      super.initState();
    });
  }

  void onChanged(value) {
    setState(() {
      selectedValue = value;
    });
  }
}
