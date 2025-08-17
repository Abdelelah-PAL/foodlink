import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../controllers/task_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/utils/size_config.dart';
import '../../providers/settings_provider.dart';
import '../../providers/task_provider.dart';
import '../../providers/users_provider.dart';
import '../widgets/custom_text.dart';
import 'add_task_screen.dart';
import 'widgets/task_tile.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  DateTime selectedDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  late ScrollController _scrollController;
  int todayIndex = 7;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (_scrollController.hasClients) {
          double offset = todayIndex * 55;
          _scrollController.jumpTo(offset);
        }
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final usersProvider = Provider.of<UsersProvider>(context, listen: false);
      Provider.of<TaskProvider>(context, listen: false).getAllTasksByDate(
          selectedDate,
          usersProvider.selectedUser!.userId,
          usersProvider.selectedUser!.userTypeId);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    left: SizeConfig.getProportionalWidth(20),
                    right: SizeConfig.getProportionalWidth(20),
                    top: SizeConfig.getProportionalWidth(20)),
                child: Column(
                  crossAxisAlignment: settingsProvider.language == "en"
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: SizeConfig.getProportionalHeight(100),
                      child: ListView.builder(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: 14,
                        itemBuilder: (context, index) {
                          DateTime currentDate = DateTime(DateTime.now().year,
                                  DateTime.now().month, DateTime.now().day)
                              .subtract(Duration(days: 7 - index));

                          bool isSelected =
                              selectedDate.day == currentDate.day &&
                                  selectedDate.month == currentDate.month &&
                                  selectedDate.year == currentDate.year;

                          return GestureDetector(
                            onTap: () async {
                              setState(() {
                                selectedDate = currentDate;
                              });

                              await Provider.of<TaskProvider>(context,
                                      listen: false)
                                  .getAllTasksByDate(
                                      currentDate,
                                      usersProvider.selectedUser!.userId,
                                      usersProvider.selectedUser!.userTypeId);

                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (_scrollController.hasClients) {
                                  double itemWidth =
                                      SizeConfig.getProportionalHeight(45) +
                                          10; // Adjust width + margins
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    final screenWidth = SizeConfig.screenWidth!;
                                    double indexOffset = (index * itemWidth) -
                                        (screenWidth / 2) +
                                        (itemWidth / 2);

                                    _scrollController.animateTo(
                                      indexOffset.clamp(
                                          0,
                                          _scrollController
                                              .position.maxScrollExtent),
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  });
                                }
                              });
                            },
                            child: Container(
                              height: SizeConfig.getProportionalHeight(79),
                              width: SizeConfig.getProportionalHeight(45),
                              margin: const EdgeInsets.symmetric(horizontal: 5),
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
                                    _getDaySubName(
                                        currentDate, settingsProvider),
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
                    Consumer<TaskProvider>(
                      builder: (ctx, taskProvider, child) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: taskProvider.tasks.length + 1,
                          itemBuilder: (ctx, index) {
                            return index == taskProvider.tasks.length
                                ? GestureDetector(
                                    onTap: () async {
                                      await Get.to(AddTaskScreen(
                                        date: selectedDate,
                                        day: _getDayName(
                                            selectedDate, settingsProvider),
                                        userId:
                                            usersProvider.selectedUser!.userId,
                                        userTypeId:
                                            usersProvider.selectedUser!.userTypeId!,
                                      ));
                                      TaskController().clearControllers();
                                    },
                                    child: Align(
                                      alignment:
                                          settingsProvider.language == 'en'
                                              ? Alignment.topLeft
                                              : Alignment.topRight,
                                      child: Container(
                                        height:
                                            SizeConfig.getProportionalHeight(
                                                38),
                                        width:
                                            SizeConfig.getProportionalWidth(38),
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.widgetsColor),
                                        child: const Icon(Icons.add),
                                      ),
                                    ),
                                  )
                                : Column(
                                    children: [
                                      TaskTile(
                                          settingsProvider: settingsProvider,
                                          task: taskProvider.tasks[index]),
                                      SizeConfig.customSizedBox(null, 10, null)
                                    ],
                                  );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  String _getDaySubName(DateTime date, SettingsProvider settingsProvider) {
    List<String> days = settingsProvider.language == "en"
        ? ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
        : [
            'الإثنين',
            'الثلاثاء',
            'الأربعاء',
            'الخميس',
            'الجمعة',
            'السبت',
            'الأحد'
          ];
    return days[date.weekday - 1];
  }

  String _getDayName(DateTime date, SettingsProvider settingsProvider) {
    final List<String> days = settingsProvider.language == 'en'
        ? [
            'Monday',
            'Tuesday',
            'Wednesday',
            'Thursday',
            'Friday',
            'Saturday',
            'Sunday'
          ]
        : [
            'الإثنين',
            'الثلاثاء',
            'الأربعاء',
            'الخميس',
            'الجمعة',
            'السبت',
            'الأحد'
          ];
    return days[date.weekday - 1];
  }
}
