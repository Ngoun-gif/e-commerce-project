import 'package:flutter/material.dart';

import '../../user/models/user.dart';
import '../../user/services/user_service.dart';
import '../services/auth_service.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/auth_response.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  String? _accessToken;
  bool _loading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isAuthenticated => _accessToken != null;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> login(String email, String password) async {
    _start();

    try {
      final req = LoginRequest(email: email, password: password);
      final AuthResponse res = await AuthService.login(req);

      _accessToken = res.accessToken;

      // Fetch authenticated user
      _user = await UserService.getMe();
    } catch (e) {
      _error = e.toString();
    }

    _finish();
  }

  Future<void> register(String fullName, String email, String password) async {
    _start();

    try {
      final req = RegisterRequest(
        fullName: fullName,
        email: email,
        password: password,
      );

      final AuthResponse res = await AuthService.register(req);

      _accessToken = res.accessToken;

      // Fetch authenticated user
      _user = await UserService.getMe();
    } catch (e) {
      _error = e.toString();
    }

    _finish();
  }

  Future<void> logout() async {
    await AuthService.clearTokens();
    _user = null;
    _accessToken = null;
    notifyListeners();
  }

  void _start() {
    _loading = true;
    _error = null;
    notifyListeners();
  }

  void _finish() {
    _loading = false;
    notifyListeners();
  }
}
