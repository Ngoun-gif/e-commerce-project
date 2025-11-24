import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/providers/auth_provider.dart';
import '../../../routers/app_routes.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              _buildHeader(),
              const SizedBox(height: 40),
              _buildLoginForm(),
              const SizedBox(height: 24),
              _buildLoginButton(),
              const SizedBox(height: 24),
              _buildRegisterLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome Back",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Sign in to continue",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        _buildEmailField(),
        const SizedBox(height: 20),
        _buildPasswordField(),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextField(
      controller: email,
      decoration: InputDecoration(
        labelText: "Email",
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: password,
      decoration: InputDecoration(
        labelText: "Password",
        prefixIcon: const Icon(Icons.lock_outline),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      obscureText: true,
    );
  }

  Widget _buildLoginButton() {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        return SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: auth.loading
                ? null
                : () => _handleLogin(auth),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D47A1), // Your specified blue
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: auth.loading
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
                : const Text(
              "Login",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRegisterLink() {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, AppRoutes.register);
        },
        child: RichText(
          text: TextSpan(
            text: "Don't have an account? ",
            style: TextStyle(
              color: Colors.grey[600],
            ),
            children: const [
              TextSpan(
                text: "Register",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin(AuthProvider auth) async {
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

      Navigator.pushReplacementNamed(context, AppRoutes.main);
    } else {
      print("====== LOGIN FAILED ======");
      print("Error: ${auth.error}");
      print("==========================");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.error ?? "Login failed"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }
}