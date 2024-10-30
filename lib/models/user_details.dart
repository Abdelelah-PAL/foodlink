class UserDetails {
  String userId;
  int? userTypeId;
  String email;
  String username;

  UserDetails({
    required this.userId,
    this.userTypeId,
    required this.email,
    required this.username
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      userId: json['userId'],
      userTypeId: json['userTypeId'],
      email: json['email'],
      username: json['username'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userTypeId': userTypeId,
      'email': email,
      'username': username
    };
  }
}
