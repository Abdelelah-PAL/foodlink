class UserSettings {
  String? id;
  String userId;
  bool activeNotifications;
  bool activeUpdates;
  String language;

  UserSettings({
    this.id,
    required this.userId,
    this.activeNotifications = true,
    this.activeUpdates = true,
    this.language = 'ar',
  });

  factory UserSettings.fromJson(Map<String, dynamic> json, id) {
    return UserSettings(
      id: id,
      userId: json['user_id'],
      activeNotifications: json['user_type_id'],
      activeUpdates: json['activeUpdates'],
      language: json['language'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'user_type_id': activeNotifications,
      'activeUpdates': activeUpdates,
      'language': language
    };
  }
}
