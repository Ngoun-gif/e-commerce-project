import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../auth/providers/auth_provider.dart';
import '../../../routers/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();

  Future<void> _debugTokens() async {
    final prefs = await SharedPreferences.getInstance();
    print("====== STORED TOKENS IN PREFS ======");
    print("accessToken: ${prefs.getString("accessToken")}");
    print("refreshToken: ${prefs.getString("refreshToken")}");
    print("userEmail: ${prefs.getString("userEmail")}");
    print("userName: ${prefs.getString("userName")}");
    print("====================================");
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: email,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: password,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: auth.loading
                  ? null
                  : () async {
                final emailVal = email.text.trim();
                final passVal = password.text.trim();

                print("\n========== LOGIN DEBUG ==========");
                print("Email: $emailVal");
                print("Password: $passVal");
                print("Calling AuthProvider.login...");
                print("=================================");

                await auth.login(emailVal, passVal);

                if (auth.isAuthenticated) {
                  print("====== LOGIN SUCCESS ======");
                  print("User: ${auth.user!.username}");
                  print("Email: ${auth.user!.email}");

                  print("=================================");

                  // show stored prefs
                  await _debugTokens();

                  Navigator.pushReplacementNamed(
                      context, AppRoutes.main);
                } else {
                  print("====== LOGIN FAILED ======");
                  print("Error: ${auth.error}");
                  print("==========================");

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(auth.error ?? "Login failed")),
                  );
                }
              },
              child: auth.loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Login"),
            ),

            const SizedBox(height: 20),

            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.register);
              },
              child: const Text("Don't have an account? Register"),
            ),
          ],
        ),
      ),
    );
  }
}
