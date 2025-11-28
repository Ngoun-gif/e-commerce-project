import 'package:flutter/material.dart';
import 'package:flutter_ecom/modules/user/models/user.dart';
import 'package:flutter_ecom/theme/app_colors.dart';

class ProfileHeader extends StatelessWidget {
  final UserModel user;

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240, // Increased from 200 to 240
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColorsPrimary.primary,
            AppColorsPrimary.primary.withOpacity(0.7),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background Pattern
          Positioned(
            right: -50,
            top: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Centered User Info
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Avatar with online indicator
                  Stack(
                    children: [
                      Container(
                        width: 100, // Increased from 80 to 100
                        height: 100, // Increased from 80 to 100
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.2),
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: Icon(
                          Icons.person,
                          size: 50, // Increased from 40 to 50
                          color: Colors.white,
                        ),
                      ),
                      if (user.active)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 24, // Increased from 20 to 24
                            height: 24, // Increased from 20 to 24
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 20), // Increased from 16 to 20

                  // User Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${user.firstname} ${user.lastname}",
                          style: const TextStyle(
                            fontSize: 24, // Increased from 20 to 24
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6), // Increased from 4 to 6
                        Text(
                          "@${user.username}",
                          style: TextStyle(
                            fontSize: 16, // Increased from 14 to 16
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 10), // Increased from 8 to 10
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16, // Increased from 12 to 16
                            vertical: 6, // Increased from 4 to 6
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            user.active ? "Active Account" : "Inactive",
                            style: const TextStyle(
                              fontSize: 14, // Increased from 12 to 14
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}