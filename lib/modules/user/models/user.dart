import 'package:flutter_ecom/utils/image_fixer.dart';

class UserModel {
  final int id;
  final String email;
  final String username;
  final String firstname;
  final String lastname;
  final String phone;
  final bool active;
  final List<String> roles;
  final String image;

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.firstname,
    required this.lastname,
    required this.phone,
    required this.active,
    required this.roles,
    required this.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"] ?? 0,
      email: json["email"] ?? "",
      username: json["username"] ?? "",
      firstname: json["firstname"] ?? json["firstName"] ?? "",
      lastname: json["lastname"] ?? json["lastName"] ?? "",
      phone: json["phone"] ?? "",
      active: json["active"] ?? false,
      roles: List<String>.from(json["roles"] ?? []),
      image: ImageFixer.fixImagePhoto(json["image"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "username": username,
      "firstname": firstname,
      "lastname": lastname,
      "phone": phone,
      "active": active,
      "roles": roles,
      "image": image,
    };
  }
}
