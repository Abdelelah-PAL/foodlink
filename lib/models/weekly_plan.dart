import 'meal.dart';

class WeeklyPlan {
  String? documentId;
  List<Map<Meal, DateTime>> daysMeals;
  String userId;
  DateTime intervalEndTime;
  DateTime intervalStartTime;

  WeeklyPlan({
    this.documentId,
    required this.daysMeals,
    required this.userId,
    required this.intervalEndTime,
    required this.intervalStartTime,
  });

  factory WeeklyPlan.fromJson(Map<String, dynamic> json, docId) {
    return WeeklyPlan(
      documentId: docId,
      daysMeals: List<Map<Meal, DateTime>>.from(json['days_meals']),
      userId: json['user_id'],
      intervalEndTime: json['interval_end_time'].toDate(),
      intervalStartTime: json['interval_start_time'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'days_meals': daysMeals,
      'user_id': userId,
      'interval_end_time': intervalEndTime,
      'interval_start_time': intervalStartTime,
    };
  }
}
