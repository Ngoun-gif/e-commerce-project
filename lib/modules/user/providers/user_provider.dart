import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/user_service.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;

  bool _loading = false;
  bool _updating = false;
  String? _error;
  String? _successMessage;

  // ========= GETTERS ===========
  UserModel? get user => _user;
  bool get loading => _loading;
  bool get updating => _updating;
  String? get error => _error;
  String? get successMessage => _successMessage;

  bool get hasUser => _user != null;
  bool get isLoggedIn => _user != null;

  // ========= LOAD USER ===========
  Future<void> loadUser() async {
    _startLoading();
    _clearMessages();

    try {
      _user = await UserService.getMe();
      _error = null;
    } catch (e) {
      _error = "Failed to load user: $e";
      _user = null;
    } finally {
      _stopLoading();
    }
  }

  // ========= UPDATE PROFILE ===========
  Future<bool> updateProfile({
    required String firstname,
    required String lastname,
    required String phone,
  }) async {
    _startUpdating();
    _clearMessages();

    try {
      _user = await UserService.updateProfile(
        firstname: firstname,
        lastname: lastname,
        phone: phone,
      );
      _successMessage = "Profile updated successfully";
      return true;
    } catch (e) {
      _error = "Update failed: $e";
      return false;
    } finally {
      _stopUpdating();
    }
  }

  // ========= CHANGE PASSWORD ===========
  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    _startUpdating();
    _clearMessages();

    try {
      await UserService.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      _successMessage = "Password updated successfully";
      return true;
    } catch (e) {
      _error = "Password change failed: $e";
      return false;
    } finally {
      _stopUpdating();
    }
  }

  // ========= LOG OUT ===========
  void clearUser() {
    _user = null;
    _loading = false;
    _updating = false;
    _error = null;
    _successMessage = null;
    notifyListeners();
  }

  // ========= HELPERS ===========
  void _clearMessages() {
    _error = null;
    _successMessage = null;
  }

  void _startLoading() {
    _loading = true;
    notifyListeners();
  }

  void _stopLoading() {
    _loading = false;
    notifyListeners();
  }

  void _startUpdating() {
    _updating = true;
    notifyListeners();
  }

  void _stopUpdating() {
    _updating = false;
    notifyListeners();
  }

  // ========= ROLE LOGIC ===========
  List<String> get roles => _user?.roles ?? [];

  bool get isAdmin =>
      roles.any((r) => r.contains("admin"));

  bool get isCustomer =>
      roles.isEmpty || roles.any((r) => r.contains("customer"));

  bool get isModerator =>
      roles.any((r) => r.contains("moderator"));
}
