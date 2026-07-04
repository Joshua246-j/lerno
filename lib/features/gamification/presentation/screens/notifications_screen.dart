import 'package:flutter/material.dart';
import 'package:lerno/core/presentation/screens/feature_preview_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePreviewScreen(
      title: 'Notifications',
      description:
          'Stay updated on rewards, friend requests, and battle invites!',
      icon: Icons.notifications_active_rounded,
    );
  }
}
