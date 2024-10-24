class UserDetails {
  String userId;
  String userTypeId;

  UserDetails({required this.userId, required this.userTypeId});

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      userId: json['userId'],
      userTypeId: json['userTypeId'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userTypeId': userTypeId,
    };
  }
}
