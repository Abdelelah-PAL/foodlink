import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_services.dart';
import 'package:intl/intl.dart';

class TaskProvider with ChangeNotifier {
  static final TaskProvider _instance = TaskProvider._internal();

  factory TaskProvider() => _instance;

  TaskProvider._internal();

  final TaskServices _ms = TaskServices();
  bool isLoading = false;
  List<Task> tasks = [];

  Future<Task> addTask(Task task) async {
    var addedTask = await _ms.addTask(task);
    return addedTask;
  }

  Future<Task> updateTask(Task task) async {
    Task updatedTask = await _ms.updateTask(task);
    return updatedTask;
  }

  Future<void> deleteTask(String docId) async {
    await _ms.deleteTask(docId);
  }

  Future<Task> getTaskById(String docId) async {
    Task task = await _ms.getTaskById(docId);
    return task;
  }

  Future<void> getAllTasksByDate(date, userId, userTypeId) async {
    try {

      isLoading = true;
      notifyListeners();
      tasks.clear();
      List<Task> fetchedTasks = await _ms.getAllTasksByDate(date, userId, userTypeId);
      for (var doc in fetchedTasks) {
        Task task = Task(
            taskName: doc.taskName,
            startTime: doc.startTime,
            endTime: doc.endTime,
            date: doc.date,
            description: doc.description,
            userId: doc.userId,
            userTypeId: userTypeId);
        tasks.add(task);
      }

      tasks.sort((a, b) => a.startTime.compareTo(b.startTime));
      isLoading = false;

      notifyListeners();
    } catch (ex) {
      isLoading = false;
      rethrow;
    }
  }

  bool checkTimeOverlapping(startTime, endTime) {
    List<Task> overLappedTasks = tasks.where(
      (task) {
        final DateFormat timeFormat = DateFormat("HH:mm");
        String taskStartClean = task.startTime.replaceAll(" ", "");
        String taskEndClean = task.endTime.replaceAll(" ", "");
        String startClean = startTime.replaceAll(" ", "");
        String endClean = endTime.replaceAll(" ", "");

        DateTime taskStartDateTime = timeFormat.parse(taskStartClean);
        DateTime taskEndDateTime = timeFormat.parse(taskEndClean);
        DateTime startDateTime = timeFormat.parse(startClean);
        DateTime endDateTime = timeFormat.parse(endClean);

        Duration taskStart = Duration(
          hours: taskStartDateTime.hour,
          minutes: taskStartDateTime.minute,
        );
        Duration taskEnd = Duration(
          hours: taskEndDateTime.hour,
          minutes: taskEndDateTime.minute,
        );
        Duration start = Duration(
          hours: startDateTime.hour,
          minutes: startDateTime.minute,
        );
        Duration end = Duration(
          hours: endDateTime.hour,
          minutes: endDateTime.minute,
        );
        return (taskStart > start && taskStart < end) ||
            (taskEnd > start && taskEnd < end);
      },
    ).toList();
    if (overLappedTasks.isEmpty) {
      return true;
    } else {
      return false;
    }
  }


}
