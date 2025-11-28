import 'package:flutter/material.dart';
import 'package:flutter_ecom/modules/user/models/user.dart';
import 'package:flutter_ecom/theme/app_colors.dart';
import 'package:provider/provider.dart';

import '../../auth/providers/auth_provider.dart';

import 'profile_header.dart';
import 'stats_row.dart';
import 'info_card.dart';
import 'info_row.dart';
import 'quick_actions.dart';
import 'logout_button.dart';

class UserProfileView extends StatelessWidget {
  final UserModel user;

  const UserProfileView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Column(
      children: [
        // Header with Avatar
        ProfileHeader(user: user),

        // Profile Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Quick Stats
                const StatsRow(),
                const SizedBox(height: 20),

                // Personal Information
                InfoCard(
                  title: "Personal Information",
                  icon: Icons.person_outline,
                  iconColor: AppColorsPrimary.primary,
                  children: [
                    InfoRow(
                      icon: Icons.email_outlined,
                      label: "Email Address",
                      value: user.email,
                      isImportant: true,
                    ),
                    InfoRow(
                      icon: Icons.phone_outlined,
                      label: "Phone Number",
                      value: user.phone.isNotEmpty ? user.phone : "Not provided",
                    ),
                    InfoRow(
                      icon: Icons.badge_outlined,
                      label: "Full Name",
                      value: "${user.firstname} ${user.lastname}",
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Account Information
                InfoCard(
                  title: "Account Information",
                  icon: Icons.security_outlined,
                  iconColor: Colors.blue,
                  children: [
                    InfoRow(
                      icon: Icons.people_outline,
                      label: "Roles",
                      value: user.roles.map((role) => role.toUpperCase()).join(', '),
                    ),
                    InfoRow(
                      icon: Icons.verified_user_outlined,
                      label: "Account Status",
                      value: user.active ? "Verified & Active" : "Pending Verification",
                      valueColor: user.active ? Colors.green : Colors.orange,
                    ),
                    InfoRow(
                      icon: Icons.calendar_today_outlined,
                      label: "Member Since",
                      value: _formatMemberSince(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Quick Actions
                const QuickActions(),
                const SizedBox(height: 32),

                // Logout Button
                LogoutButton(onLogout: () => auth.logout()),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatMemberSince() {
    // Implement based on your UserModel
    return "January 2024";
  }
}