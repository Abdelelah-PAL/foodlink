import 'package:flutter/material.dart';
import 'package:foodlink/services/notifications_services.dart';
import '../models/notification.dart';

class NotificationsProvider with ChangeNotifier {
  static final NotificationsProvider _instance = NotificationsProvider._internal();

  factory NotificationsProvider() => _instance;

  NotificationsProvider._internal();

  List<Notifications> notifications = [];
  List<Notifications> unseenNotifications = [];
  final NotificationsServices _ns = NotificationsServices();
  bool isLoading = false;



  Future<Notifications> addNotification(Notifications notification) async {
    var addedNotification = await _ns.addNotification(notification);
    return addedNotification;
  }

  Future<void> getAllNotifications(userTypeId, userId) async {
    try {
      isLoading = true;
      notifications.clear();

      List<Notifications> fetchedNotifications =
      await _ns.getAllNotifications(userTypeId, userId);
      for (var doc in fetchedNotifications) {
        Notifications notification = Notifications(
          userId: doc.userId,
          imageUrl: doc.imageUrl,
          userTypeId: doc.userTypeId,
          mealName: doc.mealName,
          missingIngredients: doc.missingIngredients,
          notes: doc.notes,
          seen: doc.seen,
          timestamp: doc.timestamp,
        );
        notifications.add(notification);
        notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        unseenNotifications  = notifications.where((notification) => !notification.seen).toList();
      }
      isLoading = false;
      notifyListeners();
    } catch (ex) {
      isLoading = false;
      rethrow;
    }
  }

  Future<void> clearUnseenNotification() async {
    unseenNotifications.clear();
    await _ns.setNotificationsToSeen();
    notifyListeners();
  }

}
