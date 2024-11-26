import 'package:cloud_firestore/cloud_firestore.dart';

class Notifications {
  String? imageUrl;
  String userId;
  int userTypeId;
  String mealName;
  List<String> missingIngredients;
  Timestamp timestamp;
  String? notes;

  Notifications(
      {this.imageUrl,
      required this.userId,
      required this.userTypeId,
      required this.mealName,
      required this.missingIngredients,
      required this.timestamp,
      required this.notes});

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
        imageUrl: json['image_url'],
        userId: json['user_id'],
        userTypeId: json['user_type_id'],
        mealName: json['meal_name'],
        missingIngredients: List<String>.from(json['missing_ingredients']),
        timestamp: json['timestamp'],
        notes: json['notes']);
  }

  Map<String, dynamic> toMap() {
    return {
      'image_url': imageUrl,
      'user_id': userId,
      'user_type_id': userTypeId,
      'meal_name': mealName,
      'missing_ingredients': missingIngredients,
      'timestamp': timestamp,
      'notes': notes
    };
  }
}
