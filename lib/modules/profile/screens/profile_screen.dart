import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_ecom/modules/auth/providers/auth_provider.dart';
import 'package:flutter_ecom/modules/user/models/user.dart';
import '../widgets/guest_view.dart';
import '../widgets/user_profile_view.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],

      body: Selector<AuthProvider, UserModel?>(
        selector: (context, auth) => auth.user,
        builder: (context, user, child) {
          final auth = Provider.of<AuthProvider>(context, listen: false);
          return auth.isAuthenticated && user != null
              ? UserProfileView(user: user)
              : const GuestView();
        },
      ),
    );
  }
}