import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lerno/core/theme/app_theme.dart';
import 'package:lerno/core/audio/audio_manager.dart';
import 'package:lerno/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:lerno/core/providers/network_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProfileProvider);
    final isOnline = ref.watch(networkProvider);

    if (user == null) {
      return const Scaffold(
        backgroundColor: AppTheme.backgroundLight,
        body: Center(child: CircularProgressIndicator(color: AppTheme.primaryBlue)),
      );
    }

    final userName = user.displayName;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isOnline)
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.wifi_off, color: Colors.orange),
                      SizedBox(width: 8),
                      Text('Offline Mode - Sync paused',
                          style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ).animate().slideY().fadeIn(),

              // Top Bar: Profile & League
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4)),
                          ],
                        ),
                        child: CircleAvatar(
                          backgroundColor: AppTheme.pastelPurple,
                          radius: 24,
                          child: SvgPicture.asset(
                            user.avatarAsset.isNotEmpty ? user.avatarAsset : 'assets/images/avatars/astronaut.svg',
                            width: 35,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Level ${user.stats.level} • ${user.stats.xp} XP',
                            style: const TextStyle(color: AppTheme.textLight, fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            userName,
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: AppTheme.textDark),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      ref.read(audioManagerProvider).playClick();
                      if (context.mounted) {
                        context.push('/leaderboard');
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.emoji_events, color: Color(0xFFFBBF24), size: 20),
                          const SizedBox(width: 6),
                          Text(
                            '${user.stats.trophies}',
                            style: TextStyle(
                                color: AppTheme.textDark.withValues(alpha: 0.8),
                                fontWeight: FontWeight.w900,
                                fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ).animate().fadeIn().slideX(),
              
              const SizedBox(height: 35),

              // Highlight: Ranked Battle
              _buildMainActionCard(
                context, 
                ref, 
                title: 'Ranked Quiz Battle', 
                subtitle: 'Compete 1v1 and earn Trophies!', 
                buttonText: 'Play Now', 
                route: '/matchmaking', 
                bgColor: const Color(0xFFFBBF24),
                icon: Icons.sports_esports,
              ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2),

              const SizedBox(height: 35),

              // Daily Rewards & Store
              const Text('Daily & Rewards', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppTheme.textDark)),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: _buildActionBtn(context, ref, 'Daily Missions', '/daily_missions', AppTheme.pastelGreen, Icons.assignment)
                        .animate().fadeIn(delay: 200.ms).slideX(),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildActionBtn(context, ref, 'Avatar Store', '/store', AppTheme.pastelBlue, Icons.storefront)
                        .animate().fadeIn(delay: 300.ms).slideX(),
                  ),
                ],
              ),

              const SizedBox(height: 35),

              // Solo Minigames
              const Text('Quick Play (Solo)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppTheme.textDark)),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withValues(alpha: 0.08), blurRadius: 15, offset: const Offset(0, 8))
                  ],
                ),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: 2.5,
                  children: [
                    _buildActivityBtn(context, ref, 'Word Hunt', '/game/word_hunt').animate().fadeIn(delay: 300.ms).scale(),
                    _buildActivityBtn(context, ref, 'Math Arena', '/game/math_arena').animate().fadeIn(delay: 350.ms).scale(),
                    _buildActivityBtn(context, ref, 'Memory Match', '/game/memory_match').animate().fadeIn(delay: 400.ms).scale(),
                    _buildActivityBtn(context, ref, 'Chess Puzzles', '/game/chess').animate().fadeIn(delay: 450.ms).scale(),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainActionCard(BuildContext context, WidgetRef ref, {required String title, required String subtitle, required String buttonText, required String route, required Color bgColor, required IconData icon}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.grey.withValues(alpha: 0.08), blurRadius: 15, offset: const Offset(0, 8))
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppTheme.textDark)),
                const SizedBox(height: 8),
                Text(subtitle, style: const TextStyle(color: AppTheme.textLight, fontSize: 13, height: 1.4)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    ref.read(audioManagerProvider).playClick();
                    if (context.mounted) {
                      context.push(route);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 4,
                    shadowColor: AppTheme.primaryBlue.withValues(alpha: 0.4),
                  ),
                  child: Text(buttonText, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                ).animate().scale(delay: 300.ms),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Container(
            width: 80,
            height: 100,
            decoration: BoxDecoration(color: bgColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
            child: Center(child: Icon(icon, color: bgColor, size: 40)),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBtn(BuildContext context, WidgetRef ref, String title, String route, Color bgColor, IconData icon) {
    return GestureDetector(
      onTap: () {
        ref.read(audioManagerProvider).playClick();
        if (context.mounted) {
          context.push(route);
        }
      },
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.08), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppTheme.textDark)),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityBtn(BuildContext context, WidgetRef ref, String title, String route) {
    return InkWell(
      onTap: () {
        ref.read(audioManagerProvider).playClick();
        if (context.mounted) {
          context.push(route);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.4), width: 1.5),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        alignment: Alignment.center,
        child: Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
      ),
    );
  }
}
