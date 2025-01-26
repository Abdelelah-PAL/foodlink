import 'package:flutter/material.dart';
import 'package:foodlink/core/constants/colors.dart';
import 'package:foodlink/core/utils/size_config.dart';
import 'package:foodlink/providers/meals_provider.dart';
import 'package:foodlink/providers/settings_provider.dart';
import '../../widgets/custom_text.dart';

class DateDropdown extends StatefulWidget {
  const DateDropdown(
      {super.key,
      required this.list,
      required this.tag,
      required this.width,
      required this.height,
      required this.settingsProvider,
      required this.mealsProvider});

  final List<String> list;
  final String tag;
  final double width;
  final double height;
  final SettingsProvider settingsProvider;
  final MealsProvider mealsProvider;

  @override
  State<DateDropdown> createState() => _DateDropdownState();
}

class _DateDropdownState extends State<DateDropdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.getProportionalWidth(widget.width),
      height: SizeConfig.getProportionalWidth(widget.height),
      decoration: BoxDecoration(
          color: AppColors.widgetsColor,
          borderRadius: BorderRadius.circular(8)),
      child: Center(
        child: DropdownButton<String>(
            underline: const SizedBox(),
            value: widget.tag == 'month'
                ? widget.mealsProvider.selectedMonth
                : widget.mealsProvider.selectedDay,
            hint: CustomText(
                isCenter: false,
                text: widget.tag,
                fontSize: widget.settingsProvider.language == 'en' ? 12 : 18,
                fontWeight: FontWeight.bold),
            items: widget.list.map((element) {
              return DropdownMenuItem(
                value: element,
                child: CustomText(
                  isCenter: false,
                  text: element,
                  fontSize: widget.settingsProvider.language == 'en' ? 12 : 18,
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList(),
            onChanged: (value) {
              widget.tag == 'month'
                  ? {
                      widget.mealsProvider.onMonthChange(value),
                      widget.mealsProvider.updateDays()
                    }
                  : widget.mealsProvider.onDayChange(value);
            }),
      ),
    );
  }
}
