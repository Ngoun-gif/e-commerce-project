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

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    email: json["email"],
    username: json["username"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    phone: json["phone"],
    active: json["active"],
    roles: List<String>.from(json["roles"].map((r) => r.toString())),
  );
}
