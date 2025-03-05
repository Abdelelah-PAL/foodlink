import 'package:flutter/material.dart';
import 'package:foodlink/controllers/task_controller.dart';
import 'package:foodlink/core/constants/colors.dart';
import 'package:foodlink/models/task.dart';
import 'package:foodlink/providers/task_provider.dart';
import 'package:foodlink/screens/dashboard/dashboard.dart';
import 'package:foodlink/screens/widgets/custom_app_textfield.dart';
import 'package:foodlink/screens/widgets/custom_back_button.dart';
import 'package:foodlink/screens/widgets/custom_button.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../controllers/general_controller.dart';
import '../../core/utils/size_config.dart';
import '../../providers/settings_provider.dart';
import '../widgets/custom_text.dart';
import '../widgets/profile_circle.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key, required this.date, required this.userId});

  final DateTime date;
  final String userId;

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TimeOfDay? _selectedTime;
  late bool isDisabled;

  @override
  void initState() {
    TaskController().startTimeController.text = "00:00";
    TaskController().endTimeController.text = "00:00";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    TaskProvider taskProvider = Provider.of<TaskProvider>(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(SizeConfig.getProportionalHeight(100)),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.getProportionalWidth(50),
                  horizontal: SizeConfig.getProportionalWidth(20)),
              child: Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const ProfileCircle(
                      height: 38,
                      width: 38,
                      iconSize: 25,
                    ),
                    CustomBackButton(onPressed: () {
                      TaskController().clearControllers();
                      Get.back();
                    })
                  ]),
            )),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.getProportionalWidth(35)),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              crossAxisAlignment: settingsProvider.language == "en"
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                const CustomText(
                    isCenter: false,
                    text: "today_system",
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
                CustomAppTextField(
                  width: 318,
                  height: 64,
                  hintText: "task_name",
                  controller: TaskController().taskNameController,
                  maxLines: 2,
                  settingsProvider: settingsProvider,
                  enabled: true,
                  isCentered: false,
                ),
                Row(
                  textDirection: settingsProvider.language == "en"
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                  children: [
                    Column(
                      crossAxisAlignment: settingsProvider.language == "en"
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.end,
                      children: [
                        const CustomText(
                            isCenter: false,
                            text: "start_time",
                            fontSize: 18,
                            fontWeight: FontWeight.normal),
                        CustomAppTextField(
                          width: 142,
                          height: 63,
                          controller: TaskController().startTimeController,
                          maxLines: 1,
                          settingsProvider: settingsProvider,
                          enabled: false,
                          onTap: () async {
                            _selectTime(context, "start");
                          },
                          isCentered: true,
                        )
                      ],
                    ),
                    SizeConfig.customSizedBox(10, null, null),
                    Column(
                      crossAxisAlignment: settingsProvider.language == "en"
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.end,
                      children: [
                        const CustomText(
                            isCenter: false,
                            text: "end_time",
                            fontSize: 18,
                            fontWeight: FontWeight.normal),
                        CustomAppTextField(
                          width: 142,
                          height: 63,
                          controller: TaskController().endTimeController,
                          maxLines: 1,
                          settingsProvider: settingsProvider,
                          enabled: false,
                          onTap: () async {
                            _selectTime(context, "end");
                          },
                          isCentered: true,
                        )
                      ],
                    )
                  ],
                ),
                const CustomText(
                    isCenter: false,
                    text: "description",
                    fontSize: 30,
                    fontWeight: FontWeight.w700),
                CustomAppTextField(
                  width: 318,
                  height: 151,
                  hintText: "description",
                  controller: TaskController().descriptionController,
                  maxLines: 10,
                  settingsProvider: settingsProvider,
                  enabled: true,
                  isCentered: false,
                ),
                SizeConfig.customSizedBox(null, 100, null),
                Center(
                  child: CustomButton(
                      onTap: () async {
                        var startTime =
                            TaskController().startTimeController.text;
                        var endTime = TaskController().endTimeController.text;
                        if (TaskController().taskNameController.text.isEmpty) {
                          setState(() {
                            isDisabled = false;
                          });
                          GeneralController().showCustomDialog(
                              context,
                              settingsProvider,
                              "task_name_is_mandatory",
                              Icons.error,
                              AppColors.errorColor,
                              null);
                          return;
                        }
                        if (TaskController()
                                .checkTimeOrder(startTime, endTime) ==
                            false) {
                          setState(() {
                            isDisabled = false;
                          });
                          GeneralController().showCustomDialog(
                              context,
                              settingsProvider,
                              "bigger_end_time",
                              Icons.error,
                              AppColors.errorColor,
                              400);
                          return;
                        }
                        if (taskProvider.checkTimeOverlapping(
                                startTime, endTime) ==
                            false) {
                          setState(() {
                            isDisabled = false;
                          });
                          GeneralController().showCustomDialog(
                              context,
                              settingsProvider,
                              "task_overlapping",
                              Icons.error,
                              AppColors.errorColor,
                              null);
                          return;
                        }
                        setState(() {
                          isDisabled = false;
                        });
                        await taskProvider.addTask(Task(
                            taskName: TaskController().taskNameController.text,
                            startTime: startTime,
                            endTime: endTime,
                            description:
                                TaskController().descriptionController.text,
                            date: widget.date,
                            userId: widget.userId));
                        TaskController().clearControllers();
                        Get.to(const Dashboard(initialIndex: 2,));
                      },
                      text: "confirm",
                      width: 126,
                      height: 45,
                    isDisabled: isDisabled,),
                )
              ],
            ),
          ),
        ));
  }

  Future<void> _selectTime(BuildContext context, String tag) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
        String formattedTime =
            '${pickedTime.hour.toString().padLeft(2, '0')} : ${pickedTime.minute.toString().padLeft(2, '0')}';
        if (tag == "start") {
          TaskController().startTimeController.text = formattedTime;
        } else {
          TaskController().endTimeController.text = formattedTime;
        }
      });
    }
  }
}
