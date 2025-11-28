import '../../user/models/user.dart';

class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final UserModel user;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    print("🔍 AuthResponse.fromJson() - JSON keys: ${json.keys}");

    // Handle different response structures
    final data = json["data"] ?? json; // Some APIs wrap in "data"

    // Handle different token field names
    final accessToken = data["accessToken"] ?? data["token"] ?? data["access_token"] ?? '';
    final refreshToken = data["refreshToken"] ?? data["refresh_token"] ?? '';

    // Handle different user field structures
    dynamic userData = data["user"] ?? data;

    // If userData is not a Map, create an empty map to avoid errors
    if (userData is! Map<String, dynamic>) {
      userData = {};
    }

    print("🔍 AuthResponse.fromJson() - accessToken: $accessToken");
    print("🔍 AuthResponse.fromJson() - userData type: ${userData.runtimeType}");

    return AuthResponse(
      accessToken: accessToken,
      refreshToken: refreshToken,
      user: UserModel.fromJson(userData),
    );
  }

  Map<String, dynamic> toJson() => {
    "accessToken": accessToken,
    "refreshToken": refreshToken,
    "user": user.toJson(),
  };
}