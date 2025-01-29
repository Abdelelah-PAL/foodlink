import 'package:flutter/material.dart';
import 'package:foodlink/providers/meals_provider.dart';
import 'package:foodlink/providers/settings_provider.dart';
import '../../../core/constants/colors.dart';
import '../../../services/translation_services.dart';

class ChangeableDate extends StatefulWidget {
  const ChangeableDate(
      {super.key, required this.settingsProvider, required this.mealsProvider});

  final SettingsProvider settingsProvider;
  final MealsProvider mealsProvider;

  @override
  State<ChangeableDate> createState() => _ChangeableDateState();
}

class _ChangeableDateState extends State<ChangeableDate> {
  @override
  Widget build(BuildContext context) {
    DateTime endDate =
        widget.mealsProvider.currentStartDate!.add(const Duration(days: 6));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.widgetsColor,
          ),
          onPressed: () {
            widget.settingsProvider.language == 'en'
                ?widget.mealsProvider.goToPreviousWeek()
                :widget.mealsProvider.goToNextWeek();
            widget.mealsProvider.resetDropdownValues();
          },
        ),
        Text(
          textDirection: widget.settingsProvider.language == 'en'
              ? TextDirection.ltr
              : TextDirection.rtl,
          '${widget.mealsProvider.currentStartDate!.day.toString()} ${TranslationService().translate(widget.mealsProvider.months[widget.mealsProvider.currentStartDate!.month - 1])} - ${endDate.day.toString()} ${TranslationService().translate(widget.mealsProvider.months[endDate.month - 1])}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.arrow_forward_ios,
            color: AppColors.widgetsColor,
          ),
          onPressed: () {
            widget.settingsProvider.language == 'en'
            ?widget.mealsProvider.goToNextWeek()
            :widget.mealsProvider.goToPreviousWeek();
            widget.mealsProvider.resetDropdownValues();
          },
        ),
      ],
    );
  }
}
