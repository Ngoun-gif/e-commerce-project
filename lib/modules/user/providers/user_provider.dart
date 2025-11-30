import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/user_service.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  bool _loading = false;
  String? _error;

  UserModel? get user => _user;
  bool get loading => _loading;
  String? get error => _error;

  bool get loggedIn => _user != null;

  Future<void> loadUser() async {
    _loading = true;
    notifyListeners();

    try {
      _user = await UserService.getMe();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _user = null;
    }

    _loading = false;
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }

  // Roles
  List<String> get roles => _user?.roles ?? [];

  bool get isAdmin =>
      roles.any((r) => r.toUpperCase() == "ADMIN");

  bool get isCustomer =>
      roles.any((r) => r.toUpperCase() == "CUSTOMER");
}
