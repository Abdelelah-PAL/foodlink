import 'package:flutter/material.dart';


class ScheduleController {
  static final ScheduleController _instance = ScheduleController._internal();

  factory ScheduleController() => _instance;

  ScheduleController._internal();

  TextEditingController taskNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();


}
