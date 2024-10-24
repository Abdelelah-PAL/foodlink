class AuthData {
  String userId;
  String? username;
  String email;
  String refreshToken;
  String token;

  AuthData({
    required this.userId,
    required this.username,
    required this.email,
    required this.refreshToken,
    required this.token,
  });
  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      userId: json['localId'],
      username: json['displayName'],
      email: json['email'],
      refreshToken: json['refreshToken'],
      token: json['idToken'],
    );
  }
}
