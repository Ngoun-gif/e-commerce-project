import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),

              TextField(
                controller: passCtrl,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
              const SizedBox(height: 20),

              loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                onPressed: () async {
                  setState(() => loading = true);

                  try {
                    await auth.register(
                      nameCtrl.text.trim(),
                      emailCtrl.text.trim(),
                      passCtrl.text.trim(),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Register successful")),
                    );

                    Navigator.pushReplacementNamed(context, "/login");

                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Register failed: $e")),
                    );
                  }

                  setState(() => loading = false);
                },
                child: const Text("Create Account"),
              ),

              const SizedBox(height: 20),

              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/login");
                },
                child: const Text("Already have an account? Login"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
