class RegisterRequest {
  final String email;
  final String password;
  final String username;
  final String firstname;
  final String lastname;
  final String phone;

  RegisterRequest({
    required this.email,
    required this.password,
    required this.username,
    required this.firstname,
    required this.lastname,
    required this.phone,
  });

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
    "username": username,
    "firstname": firstname,
    "lastname": lastname,
    "phone": phone,
  };
}