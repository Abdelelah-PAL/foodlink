import 'package:flutter/material.dart';
import 'package:foodlink/core/constants/colors.dart';
import 'package:foodlink/providers/settings_provider.dart';
import 'package:foodlink/providers/task_provider.dart';
import 'package:foodlink/providers/users_provider.dart';
import 'package:foodlink/screens/schedule/widgets/task_tile.dart';
import 'package:foodlink/screens/widgets/custom_text.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../core/utils/size_config.dart';
import '../widgets/profile_circle.dart';
import 'add_task_screen.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  DateTime selectedDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final usersProvider = Provider.of<UsersProvider>(context, listen: false);
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      taskProvider.getAllTasksByDate(
          selectedDate, usersProvider.selectedUser!.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    UsersProvider usersProvider = Provider.of<UsersProvider>(context);
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    TaskProvider taskProvider = Provider.of<TaskProvider>(context);

    return taskProvider.isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: AppColors.backgroundColor,
            appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(SizeConfig.getProportionalHeight(100)),
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
                      ))),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.getProportionalWidth(20)
                ),
                child: Column(
                  crossAxisAlignment: settingsProvider.language == "en"
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 7,
                        itemBuilder: (context, index) {
                          DateTime currentDate =
                              DateTime.now().add(Duration(days: index));
                          bool isSelected = selectedDate.day == currentDate.day &&
                              selectedDate.month == currentDate.month &&
                              selectedDate.year == currentDate.year;
                
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedDate = currentDate;
                              });
                              taskProvider.getAllTasksByDate(currentDate,
                                  usersProvider.selectedUser!.userId);
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
                    const CustomText(
                        isCenter: false,
                        text: "today_system",
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                    SizedBox(
                      height: 500,
                      child: Consumer<TaskProvider>(
                        builder: (ctx, taskProvider, child) {
                          return ListView.builder(
                            itemCount: taskProvider.tasks.length + 1,
                            itemBuilder: (ctx, index) {
                              return index == taskProvider.tasks.length
                                  ? GestureDetector(
                                      onTap: () {
                                        Get.to(AddTaskScreen(
                                            date: selectedDate,
                                            userId: usersProvider
                                                .selectedUser!.userId));
                                      },
                                      child: Container(
                                        height:
                                            SizeConfig.getProportionalHeight(
                                                38),
                                        width:
                                            SizeConfig.getProportionalWidth(
                                                38),
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.widgetsColor),
                                        child: const Icon(Icons.add),
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        TaskTile(
                                            settingsProvider:
                                                settingsProvider,
                                            task: taskProvider.tasks[index]),
                                        SizeConfig.customSizedBox(
                                            null, 10, null)
                                      ],
                                    );
                            },
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }

  String _getDayName(DateTime date) {
    const List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }
}
