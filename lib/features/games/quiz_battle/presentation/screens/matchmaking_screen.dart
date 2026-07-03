import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lerno/core/theme/app_theme.dart';
import '../../domain/models/battle_state.dart';
import '../providers/quiz_battle_provider.dart';
import 'package:lerno/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:lerno/core/audio/audio_manager.dart';

class MatchmakingScreen extends ConsumerStatefulWidget {
  const MatchmakingScreen({super.key});

  @override
  ConsumerState<MatchmakingScreen> createState() => _MatchmakingScreenState();
}

class _MatchmakingScreenState extends ConsumerState<MatchmakingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: false);
    _animation = Tween<double>(begin: 0.5, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(quizBattleProvider.notifier).startMatchmaking();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);
    final myAvatar = userProfile?.avatarAsset.isNotEmpty == true ? userProfile!.avatarAsset : 'assets/images/avatars/octopus.svg';

    ref.listen<BattleState>(quizBattleProvider, (previous, next) {
      if (next.status == MatchStatus.playing) {
        ref.read(audioManagerProvider).playSuccess();
        context.pushReplacement('/battle_arena');
      }
    });

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Searching for Opponent...',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryBlue),
            ),
            const SizedBox(height: 50),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 150 * _animation.value,
                      height: 150 * _animation.value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.primaryBlue
                            .withValues(alpha: 1.0 - (_animation.value - 0.5)),
                      ),
                    ),
                    Container(
                      width: 100 * _animation.value,
                      height: 100 * _animation.value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.primaryGreen
                            .withValues(alpha: 1.0 - (_animation.value - 0.5)),
                      ),
                    ),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: SvgPicture.asset(myAvatar, width: 70),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                ref.read(quizBattleProvider.notifier).reset();
                Navigator.pop(context);
              },
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
