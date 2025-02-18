import 'package:flutter/material.dart';


class TaskController {
  static final TaskController _instance = TaskController._internal();

  factory TaskController() => _instance;

  TaskController._internal();

  TextEditingController taskNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();






}
