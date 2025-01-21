import 'package:flutter/material.dart';
import 'package:foodlink/models/meal.dart';
import 'package:foodlink/providers/meals_provider.dart';
import 'package:foodlink/providers/settings_provider.dart';
import 'package:foodlink/screens/widgets/custom_text.dart';
import 'package:foodlink/services/translation_services.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/size_config.dart';

class DayMealRow extends StatefulWidget {
  const DayMealRow(
      {super.key,
      required this.day,
      required this.month,
      required this.dayName,
      required this.index,
      required this.settingsProvider,
      required this.mealsProvider});

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
  String? selectedValue;

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
        GestureDetector(
          child: Container(
            width: SizeConfig.getProportionalWidth(245),
            height: SizeConfig.getProportionalHeight(40),
            margin: EdgeInsets.symmetric(
                vertical: SizeConfig.getProportionalHeight(10)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(width: 3.0, color: AppColors.widgetsColor),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.getProportionalWidth(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                textDirection: widget.settingsProvider.language == 'en'
                    ? TextDirection.ltr
                    : TextDirection.rtl,
                children: const [
                  CustomText(
                      isCenter: false,
                      text: 'select_meal',
                      fontSize: 18,
                      fontWeight: FontWeight.w400),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 24,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            // child: DropdownButton<String>(
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
            // )
          ),
        ),
        const Divider(
          thickness: 1,
          color: Colors.grey,
        )
      ],
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
}
