class UserDetails {
  String userId;
  int? userTypeId;
  String email;
  String? username;
  String? imageUrl;
  bool subscriber;

  UserDetails(
      {required this.userId,
      this.userTypeId,
      required this.email,
      this.username,
      this.imageUrl,
      required this.subscriber});

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
        userId: json['user_id'],
        userTypeId: json['user_type_id'],
        email: json['email'],
        username: json['username'],
        imageUrl: json['image_url'],
        subscriber: json['subscriber']);
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'user_type_id': userTypeId,
      'email': email,
      'username': username,
      'image_url': imageUrl,
      'subscriber': subscriber
    };
  }
}
