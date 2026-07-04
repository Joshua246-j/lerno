import 'package:flutter/material.dart';
import 'package:lerno/core/presentation/screens/feature_preview_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePreviewScreen(
      title: 'Global Search',
      description: 'Search for new courses, games, players, and friends!',
      icon: Icons.search_rounded,
    );
  }
}
