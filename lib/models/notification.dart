class Notifications {
  String text;
  String? imageUrl;
  String userId;
  int userTypeId;
  String mealId;

  Notifications({
    required this.text,
    this.imageUrl,
    required this.userId,
    required this.userTypeId,
    required this.mealId,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
        text: json['text'],
        imageUrl: json['image_url'],
        userId: json['user_id'],
        userTypeId: json['user_type_id'],
        mealId:  json['meal_id']);
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'image_url': imageUrl,
      'user_id': userId,
      'user_type_id': userTypeId,
      'meal_id': mealId
    };
  }
}
