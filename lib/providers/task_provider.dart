import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_services.dart';

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

  Future<void> getAllTasksByDate(date, userId) async {
    try {
      isLoading = true;
      tasks.clear();
      List<Task> fetchedTasks = await _ms.getAllTasksByDate(date, userId);
      for (var doc in fetchedTasks) {
        Task task = Task(
            taskName: doc.taskName,
            startTime: doc.startTime,
            endTime: doc.endTime,
            date: doc.date);
        tasks.add(task);
      }
      isLoading = false;
      notifyListeners();
    } catch (ex) {
      isLoading = false;
      rethrow;
    }
  }
}
