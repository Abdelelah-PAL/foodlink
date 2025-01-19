import 'package:flutter/material.dart';
import 'package:foodlink/core/constants/colors.dart';
import 'package:foodlink/providers/settings_provider.dart';
import 'package:foodlink/screens/widgets/custom_text.dart';
import 'package:provider/provider.dart';
import '../../core/utils/size_config.dart';
import '../widgets/profile_circle.dart';

class DietFoodSystem extends StatefulWidget {
  const DietFoodSystem({super.key});

  @override
  State<DietFoodSystem> createState() => _DietFoodSystemState();
}

class _DietFoodSystemState extends State<DietFoodSystem> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(SizeConfig.getProportionalHeight(100)),
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.getProportionalWidth(20),
                    horizontal: SizeConfig.getProportionalWidth(20)),
                child: const ProfileCircle(
                  height: 38,
                  width: 38,
                  iconSize: 25,
                )),
          )),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.getProportionalWidth(20)),
        child: Column(
          crossAxisAlignment: settingsProvider.language == "en"
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 7,
                    itemBuilder: (context, index) {
                      DateTime currentDate =
                          DateTime.now().add(Duration(days: index));
                      bool isSelected = _selectedDate.day == currentDate.day &&
                          _selectedDate.month == currentDate.month &&
                          _selectedDate.year == currentDate.year;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedDate = currentDate;
                          });
                        },
                        child: Container(
                          height: SizeConfig.getProportionalHeight(79),
                          width: SizeConfig.getProportionalHeight(53),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.widgetsColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.widgetsColor
                                  : Colors.transparent,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                currentDate.day.toString(),
                                style: const TextStyle(
                                  color: AppColors.fontColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizeConfig.customSizedBox(8, null, null),
                              Text(
                                _getDayName(currentDate),
                                style: TextStyle(
                                    color: AppColors.fontColor,
                                    fontSize: 14,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                              ),
                              SizeConfig.customSizedBox(null, 8, null),
                              isSelected
                                  ? Container(
                                      width: 6.0,
                                      height: 6.0,
                                      decoration: const BoxDecoration(
                                        color: Colors.black,
                                        shape: BoxShape.circle,
                                      ),
                                    )
                                  : const SizedBox()
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
            const CustomText(
                isCenter: false,
                text: "today_food_system",
                fontSize: 30,
                fontWeight: FontWeight.bold)
          ],
        ),
      ),
    );
  }

  String _getDayName(DateTime date) {
    const List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }
}
