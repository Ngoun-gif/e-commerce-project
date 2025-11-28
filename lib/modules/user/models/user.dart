class UserModel {
  final int id;
  final String email;
  final String username;
  final String firstname;
  final String lastname;
  final String phone;
  final bool active;
  final List<String> roles;

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.firstname,
    required this.lastname,
    required this.phone,
    required this.active,
    required this.roles,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    print("🔍 UserModel.fromJson() - JSON keys: ${json.keys}");
    print("🔍 UserModel.fromJson() - id: ${json["id"]} (type: ${json["id"]?.runtimeType})");
    print("🔍 UserModel.fromJson() - email: ${json["email"]}");
    print("🔍 UserModel.fromJson() - username: ${json["username"]}");

    return UserModel(
      id: json["id"] ?? 0, // Handle null id
      email: json["email"] ?? '',
      username: json["username"] ?? '',
      firstname: json["firstname"] ?? json["firstName"] ?? '', // Handle different casing
      lastname: json["lastname"] ?? json["lastName"] ?? '', // Handle different casing
      phone: json["phone"] ?? '',
      active: json["active"] ?? json["isActive"] ?? false, // Handle different field names
      roles: List<String>.from((json["roles"] ?? json["role"] ?? []).map((r) => r.toString())),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "username": username,
    "firstname": firstname,
    "lastname": lastname,
    "phone": phone,
    "active": active,
    "roles": roles,
  };
}