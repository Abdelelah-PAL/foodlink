import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../models/notification.dart';

class NotificationsServices with ChangeNotifier {
  final _firebaseFireStore = FirebaseFirestore.instance;

  Future<Notifications> addNotification(Notifications notification) async {
    try {
      var addedNotification = await _firebaseFireStore
          .collection('notifications')
          .add(notification.toMap());
      var mealSnapshot = await addedNotification.get();

      return Notifications.fromJson(mealSnapshot.data()!);
    } catch (ex) {
      rethrow;
    }
  }

  Future<List<Notifications>> getAllNotifications(
      int userTypeId, String userId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> notificationsQuery =
          await _firebaseFireStore
              .collection('notifications')
              .where('user_type_id', isEqualTo: userTypeId)
              .where('user_id', isEqualTo: userId)
              .get();

      List<Notifications> notifications = notificationsQuery.docs.map((doc) {
        return Notifications.fromJson(doc.data());
      }).toList();

      return notifications;
    } catch (ex) {
      rethrow;
    }
  }

  Future<void> setNotificationsToSeen() async {
    try {
      final collectionRef =
          FirebaseFirestore.instance.collection('notifications');
      final querySnapshot =
          await collectionRef.where('seen', isEqualTo: false).get();

      final batch = FirebaseFirestore.instance.batch();

      for (var doc in querySnapshot.docs) {
        batch.update(doc.reference, {'seen': true});
      }
      await batch.commit();
    } catch (ex) {
      rethrow;
    }
  }
}
