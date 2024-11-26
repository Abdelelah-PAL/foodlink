import 'package:cloud_firestore/cloud_firestore.dart';

class Notifications {
  String? imageUrl;
  String userId;
  int userTypeId;
  String mealName;
  Timestamp timestamp;

  Notifications({
    this.imageUrl,
    required this.userId,
    required this.userTypeId,
    required this.mealName,
    required this.timestamp,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
        imageUrl: json['image_url'],
        userId: json['user_id'],
        userTypeId: json['user_type_id'],
        mealName:  json['meal_name'],
        timestamp: json['timestamp']);
  }

  Map<String, dynamic> toMap() {
    return {
      'image_url': imageUrl,
      'user_id': userId,
      'user_type_id': userTypeId,
      'meal_name': mealName,
      'timestamp': timestamp
    };
  }
}
