import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0D47A1)),
          ),
          SizedBox(height: 16),
          Text(
            "Loading all payments...",
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF0D47A1),
            ),
          ),
        ],
      ),
    );
  }
}