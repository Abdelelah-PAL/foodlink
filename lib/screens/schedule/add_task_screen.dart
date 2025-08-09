import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import '../../controllers/general_controller.dart';
import '../../controllers/task_controller.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';
import '../../core/utils/size_config.dart';
import '../../models/task.dart';
import '../../providers/settings_provider.dart';
import '../../providers/task_provider.dart';
import '../dashboard/dashboard.dart';
import '../widgets/custom_app_textfield.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';
import 'package:intl/intl.dart' as intl;

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen(
      {super.key, required this.date, required this.userId, required this.day});

  final DateTime date;
  final String day;
  final String userId;

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TimeOfDay? _selectedTime;
  bool isDisabled = true;

  @override
  void initState() {
    TaskController().startTimeController.text = "00:00";
    TaskController().endTimeController.text = "00:00";
    initializeDateFormatting('ar_SA', null);
    initializeDateFormatting('en_US', null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    TaskProvider taskProvider = Provider.of<TaskProvider>(context);
    String formattedDate = settingsProvider.language == "en"
        ? intl.DateFormat.yMMMMd('en_US')
            .format(widget.date)
            .split(' ')
            .reversed
            .join(' ')
        : intl.DateFormat.yMMMMd('ar_SA')
            .format(widget.date)
            .split(' ')
            .reversed
            .join(' ');
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(SizeConfig.getProportionalHeight(0)),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.getProportionalHeight(50),
                  horizontal: SizeConfig.getProportionalWidth(20)),
              child: Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomBackButton(onPressed: () {
                      TaskController().clearControllers();
                      Get.back();
                    })
                  ]),
            )),
        body: Padding(
          padding: EdgeInsets.only(
              top: SizeConfig.getProportionalHeight(50),
              left: SizeConfig.getProportionalWidth(35),
              right: SizeConfig.getProportionalWidth(35),
              bottom: SizeConfig.getProportionalHeight(30)),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              crossAxisAlignment: settingsProvider.language == "en"
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: RichText(
                      textDirection: settingsProvider.language == 'en'
                          ? TextDirection.ltr
                          : TextDirection.rtl,
                      text: TextSpan(
                          children: [
                            TextSpan(
                                text: '${widget.day}  ',
                                style: const TextStyle(
                                  color: AppColors.widgetsColor,
                                )),
                            TextSpan(
                                text: formattedDate,
                                style: const TextStyle(
                                  color: AppColors.fontColor,
                                ))
                          ],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            fontFamily: AppFonts.getPrimaryFont(context),
                          ))),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: SizeConfig.getProportionalHeight(50),
                      bottom: SizeConfig.getProportionalHeight(25)),
                  child: const CustomText(
                      isCenter: false,
                      text: "today_system",
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
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
                Padding(
                  padding: EdgeInsets.only(
                      bottom: SizeConfig.getProportionalHeight(25)),
                  child: Row(
                    textDirection: settingsProvider.language == "en"
                        ? TextDirection.ltr
                        : TextDirection.rtl,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              fontWeight: FontWeight.w700),
                          SizeConfig.customSizedBox(null, 10, null),
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
                      Column(
                        crossAxisAlignment: settingsProvider.language == "en"
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.end,
                        children: [
                          const CustomText(
                              isCenter: false,
                              text: "end_time",
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                          SizeConfig.customSizedBox(null, 10, null),
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
                ),
                const CustomText(
                    isCenter: false,
                    text: "description",
                    fontSize: 30,
                    fontWeight: FontWeight.w700),
                SizeConfig.customSizedBox(null, 10, null),
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
                SizeConfig.customSizedBox(null, 80, null),
                Center(
                  child: CustomButton(
                    onTap: () async {
                      var startTime = TaskController().startTimeController.text;
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
                      if (TaskController().checkTimeOrder(startTime, endTime) ==
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
                      Get.to(const Dashboard(
                        initialIndex: 2,
                      ));
                    },
                    text: "confirm",
                    width: 126,
                    height: 45,
                    isDisabled: isDisabled,
                    fontSize: 30,
                  ),
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
