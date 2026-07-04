import 'package:flutter/material.dart';
import 'package:lerno/core/presentation/screens/feature_preview_screen.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePreviewScreen(
      title: 'Inbox',
      description: 'Send and receive messages from your friends.\nChallenge them to Quiz Battles!',
      icon: Icons.inbox_rounded,
    );
  }
}
