import 'package:flutter/material.dart';
import '../modules/auth/services/auth_service.dart';
import '../routers/app_routes.dart';

Future<void> requireLogin(
    BuildContext context,
    Future<void> Function() action,
    ) async {
  final token = await AuthService.getToken();

  if (token == null) {
    // Redirect to login
    Navigator.pushNamed(context, AppRoutes.login);
    return;
  }

  try {
    await action();
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
    rethrow;
  }
}
