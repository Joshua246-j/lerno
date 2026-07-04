import 'package:flutter/material.dart';
import 'package:lerno/core/presentation/screens/feature_preview_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePreviewScreen(
      title: 'Settings',
      description: 'Manage your account, audio, privacy, and app preferences.',
      icon: Icons.settings_rounded,
    );
  }
}
