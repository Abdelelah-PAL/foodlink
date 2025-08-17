import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../models/task.dart';

class TaskServices with ChangeNotifier {
  final _firebaseFireStore = FirebaseFirestore.instance;

  Future<Task> addTask(task) async {
    try {
      var addedTask =
          await _firebaseFireStore.collection('tasks').add(task.toMap());
      var taskSnapshot = await addedTask.get();

      return Task.fromJson(taskSnapshot.data()!, addedTask.id);
    } catch (ex) {
      rethrow;
    }
  }

  Future<List<Task>> getAllTasksByDate(DateTime date, String userId, int userTypeId ) async {
    try {

      QuerySnapshot<Map<String, dynamic>> taskQuery = await _firebaseFireStore
          .collection('tasks')
          .where('date', isEqualTo: date)
          .where('user_id', isEqualTo: userId)
          .where('user_type_id', isEqualTo: userTypeId)
          .get();

      List<Task> tasks = taskQuery.docs.map((doc) {
        return Task.fromJson(doc.data(), doc.id);
      }).toList();

      return tasks;
    } catch (ex) {
      rethrow;
    }
  }

  Future<Task> updateTask(Task task) async {
    try {
      await _firebaseFireStore
          .collection('tasks')
          .doc(task.documentId)
          .set(
        task.toMap(),
            SetOptions(merge: false),
          );
      var docRef =
          _firebaseFireStore.collection('tasks').doc(task.documentId);
      var docSnapshot = await docRef.get();

      Task updatedTask = Task.fromJson(docSnapshot.data()!, task.documentId);
      return updatedTask;
    } catch (ex) {
      rethrow;
    }
  }

  Future<void> deleteTask(String docId) async {
    await _firebaseFireStore.collection('tasks').doc(docId).delete();
  }

  Future<Task> getTaskById(String docId) async {
    try {
      DocumentSnapshot taskSnapshot =
          await _firebaseFireStore.collection('tasks').doc(docId).get();
      return Task.fromJson(taskSnapshot.data() as Map<String, dynamic>, docId);
    } catch (ex) {
      rethrow;
    }
  }

}
