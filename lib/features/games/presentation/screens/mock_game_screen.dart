import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lerno/core/theme/app_theme.dart';
import 'package:lerno/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:lerno/features/gamification/data/repositories/gamification_repository.dart';

class MockGameScreen extends ConsumerStatefulWidget {
  final String courseId;
  const MockGameScreen({super.key, required this.courseId});

  @override
  ConsumerState<MockGameScreen> createState() => _MockGameScreenState();
}

class _MockGameScreenState extends ConsumerState<MockGameScreen> {
  bool _isPlaying = true;

  void _finishGame() {
    setState(() {
      _isPlaying = false;
    });

    // Reward player using Gamification Repository
    final repo = ref.read(gamificationRepositoryProvider);
    final profile = ref.read(userProfileProvider);

    if (profile != null) {
      repo.resolveSoloGame(profile,
          isWin: true, score: 1500); // Simulated win score
      ref.read(userProfileProvider.notifier).refreshProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBBF24), // Game background
      body: SafeArea(
        child: Center(
          child: _isPlaying
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Playing Game...',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 50),
                    ElevatedButton(
                      onPressed: _finishGame,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text('Simulate Win',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    )
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, size: 100, color: Colors.white),
                    const SizedBox(height: 20),
                    const Text(
                      'Level Complete!',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '+150 XP   +20 Coins   +1 Trophy',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 50),
                    ElevatedButton(
                      onPressed: () => context.pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text('Continue',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
