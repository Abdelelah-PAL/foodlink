import 'package:flutter/material.dart';
import 'package:foodlink/controllers/schedule_controller.dart';
import 'package:foodlink/screens/widgets/custom_app_textfield.dart';
import 'package:foodlink/screens/widgets/custom_back_button.dart';
import 'package:foodlink/screens/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import '../../core/utils/size_config.dart';
import '../../providers/settings_provider.dart';
import '../widgets/custom_text.dart';
import '../widgets/profile_circle.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    ScheduleController().startTimeController.text = "00:00";
    ScheduleController().endTimeController.text = "00:00";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(SizeConfig.getProportionalHeight(100)),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.getProportionalWidth(50),
                  horizontal: SizeConfig.getProportionalWidth(20)),
              child: const Row(
                  textDirection: TextDirection.rtl,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ProfileCircle(
                      height: 38,
                      width: 38,
                      iconSize: 25,
                    ),
                    CustomBackButton()
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
                  controller: ScheduleController().taskNameController,
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
                          controller: ScheduleController().startTimeController,
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
                          controller: ScheduleController().endTimeController,
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
                  controller: ScheduleController().descriptionController,
                  maxLines: 10,
                  settingsProvider: settingsProvider,
                  enabled: true,
                  isCentered: false,
                ),
                SizeConfig.customSizedBox(null, 100, null),
                Center(
                  child: CustomButton(
                      onTap: () {}, text: "confirm", width: 126, height: 45),
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
        if (tag == "start") {
          ScheduleController().startTimeController.text =
              '${pickedTime.hour.toString()} : ${pickedTime.minute.toString()}';
        } else {
          ScheduleController().endTimeController.text =
              '${pickedTime.hour.toString()} : ${pickedTime.minute.toString()}';
        }
      });
    }
  }
}
