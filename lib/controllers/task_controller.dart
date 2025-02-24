import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class TaskController {
  static final TaskController _instance = TaskController._internal();

  factory TaskController() => _instance;

  TaskController._internal();

  TextEditingController taskNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();


  bool checkTimeOrder(startTime, endTime) {
    final DateFormat timeFormat = DateFormat("HH:mm");
    String startClean = startTime.replaceAll(" ", "");
    String endClean = endTime.replaceAll(" ", "");

    DateTime startDateTime = timeFormat.parse(startClean);
    DateTime endDateTime = timeFormat.parse(endClean);

    Duration start = Duration(
      hours: startDateTime.hour,
      minutes: startDateTime.minute,
    );
    Duration end = Duration(
      hours: endDateTime.hour,
      minutes: endDateTime.minute,
    );
    if (start < end) {
      return true;
    } else {
      return false;
    }
  }

  void clearControllers() {
    descriptionController.clear();
    taskNameController.clear();
  }
}
