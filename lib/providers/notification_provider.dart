import 'package:flutter/material.dart';
import 'package:foodlink/controllers/user_types.dart';
import 'package:foodlink/services/notifications_services.dart';
import '../models/notification.dart';

class NotificationsProvider with ChangeNotifier {
  static final NotificationsProvider _instance =
      NotificationsProvider._internal();

  factory NotificationsProvider() => _instance;

  NotificationsProvider._internal();

  List<Notifications> userNotifications = [];
  List<Notifications> userUnseenNotifications = [];
  List<Notifications> cookerNotifications = [];
  List<Notifications> cookerUnseenNotifications = [];
  final NotificationsServices _ns = NotificationsServices();
  bool isLoading = false;

  Future<Notifications> addNotification(Notifications notification) async {
    var addedNotification = await _ns.addNotification(notification);
    return addedNotification;
  }

  Future<void> getAllNotifications(userTypeId, userId) async {
    try {
      isLoading = true;
      userNotifications.clear();
      cookerNotifications.clear();

      List<Notifications> fetchedNotifications =
          await _ns.getAllNotifications(userTypeId, userId);
      for (var doc in fetchedNotifications) {
        Notifications notification = Notifications(
          userId: doc.userId,
          imageUrl: doc.imageUrl,
          userTypeId: doc.userTypeId,
          mealId: doc.mealId,
          mealName: doc.mealName,
          missingIngredients: doc.missingIngredients,
          notes: doc.notes,
          seen: doc.seen,
          timestamp: doc.timestamp,
          isMealPlanned: doc.isMealPlanned
        );
        if (doc.userTypeId == UserTypes.user) {
          userNotifications.add(notification);
          userNotifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
          userUnseenNotifications = userNotifications
              .where((notification) => !notification.seen)
              .toList();
        } else {
          cookerNotifications.add(notification);
          cookerNotifications
              .sort((a, b) => b.timestamp.compareTo(a.timestamp));
          cookerUnseenNotifications = cookerNotifications
              .where((notification) => !notification.seen)
              .toList();
        }
      }

      isLoading = false;
      notifyListeners();
    } catch (ex) {
      isLoading = false;
      rethrow;
    }
  }

  Future<void> clearUnseenNotification(userTypeId) async {
    if(userTypeId == UserTypes.user) {
      userUnseenNotifications.clear();
    }
    else {
      cookerUnseenNotifications.clear();
    }
    await _ns.setNotificationsToSeen(userTypeId);
    notifyListeners();
  }
}
