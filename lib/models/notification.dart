import 'package:cloud_firestore/cloud_firestore.dart';

class Notifications {
  String? imageUrl;
  String userId;
  int userTypeId;
  String mealId;
  String mealName;
  List<String> missingIngredients;
  String? notes;
  bool seen;
  Timestamp timestamp;
  bool isMealPlanned;

  Notifications(
      {this.imageUrl,
      required this.userId,
      required this.userTypeId,
      required this.mealName,
      required this.mealId,
      required this.missingIngredients,
      required this.notes,
      required this.seen,
      required this.timestamp,
      required this.isMealPlanned});

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
        imageUrl: json['image_url'],
        userId: json['user_id'],
        userTypeId: json['user_type_id'],
        mealName: json['meal_name'],
        mealId:  json['meal_id'],
        missingIngredients: List<String>.from(json['missing_ingredients']),
        notes: json['notes'],
        seen: json['seen'],
        timestamp: json['timestamp'],
        isMealPlanned: json['is_meal_planned']);
  }

  Map<String, dynamic> toMap() {
    return {
      'image_url': imageUrl,
      'user_id': userId,
      'user_type_id': userTypeId,
      'meal_id': mealId,
      'meal_name': mealName,
      'missing_ingredients': missingIngredients,
      'notes': notes,
      'seen': seen,
      'timestamp': timestamp,
      'is_meal_planned': isMealPlanned
    };
  }
}
