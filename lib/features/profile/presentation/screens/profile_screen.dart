import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lerno/features/gamification/domain/models/league_system.dart';
import 'package:lerno/features/gamification/presentation/widgets/league_shield_widget.dart';
import 'package:lerno/core/theme/app_theme.dart';
import 'package:lerno/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:lerno/features/gamification/presentation/screens/league_leaderboard_screen.dart';
import 'package:lerno/features/gamification/data/repositories/gamification_repository.dart';
import 'package:lerno/core/widgets/mountain_background.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    final userName = profile?.displayName ?? 'Guest';
    final avatar = profile?.avatarAsset.isNotEmpty == true ? profile!.avatarAsset : 'assets/images/avatars/octopus.svg';

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.settings, color: AppTheme.textLight),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: AppTheme.textLight),
            onPressed: () {},
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Mountain Background at bottom
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: MountainBackground(),
          ),

          // Main Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Avatar & Name with Edit Button
                  Stack(
                    children: [
                      Center(
                        child: Container(
                          width: 120,
                          height: 120,
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.1),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8))
                            ],
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.pastelPurple,
                            ),
                            child: ClipOval(
                              child:
                                  SvgPicture.asset(avatar, fit: BoxFit.scaleDown),
                            ),
                          ),
                        ).animate().scale(
                            delay: 200.ms,
                            duration: 400.ms,
                            curve: Curves.easeOutBack),
                      ),
                      Positioned(
                        bottom: 0,
                        right: MediaQuery.of(context).size.width / 2 - 60,
                        child: GestureDetector(
                          onTap: () {
                            // Navigate to edit profile
                            if (context.mounted) {
                              context.push('/edit_profile');
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryBlue,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                            child: const Icon(Icons.edit, color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(userName,
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.textDark))
                      .animate()
                      .fadeIn(delay: 300.ms),
                  Text('${profile?.age ?? 0} Years Old',
                          style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                              fontSize: 14))
                      .animate()
                      .fadeIn(delay: 300.ms),
                  const SizedBox(height: 8),
                  Text('Level ${profile?.stats.level ?? 1}',
                          style: const TextStyle(
                              color: AppTheme.primaryBlue,
                              fontWeight: FontWeight.w800,
                              fontSize: 16))
                      .animate()
                      .fadeIn(delay: 300.ms),
                  const SizedBox(height: 20),

                  // Stats Row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        _buildStatCard(
                            '${profile?.stats.currentStreak ?? 0}',
                            'Streak',
                            Icons.local_fire_department,
                            AppTheme.pastelPurple,
                            const Color(0xFFFF9800)),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Container(
                            height: 110,
                            decoration: BoxDecoration(
                              color: AppTheme.pastelGreen,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                    color: AppTheme.pastelGreen,
                                    blurRadius: 10,
                                    offset: Offset(0, 4))
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    const SizedBox(
                                      width: 45,
                                      height: 45,
                                      child: CircularProgressIndicator(
                                          value: 0.7,
                                          color: AppTheme.primaryGreen,
                                          backgroundColor: Colors.white,
                                          strokeWidth: 5),
                                    ),
                                    Text('${profile?.stats.level ?? 1}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 16,
                                            color: AppTheme.textDark)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Text('Level',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textDark,
                                        fontSize: 13)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        GestureDetector(
                          onTap: () async {
                            final board = await ref
                                .read(gamificationRepositoryProvider)
                                .fetchLeagueLeaderboard(profile?.stats.league ?? 'Bronze');
                            if (context.mounted) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => LeagueLeaderboardScreen(
                                          currentLeague: profile?.stats.league ?? 'Bronze',
                                          leaderboard: board)));
                            }
                          },
                          child: Container(
                            height: 110,
                            decoration: BoxDecoration(
                              color: AppTheme.pastelBlue,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                    color: AppTheme.pastelBlue,
                                    blurRadius: 10,
                                    offset: Offset(0, 4))
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: LeagueShieldWidget(
                                    league: LeagueTier.getLeagueForTrophies(
                                        profile?.stats.trophies ?? 0),
                                    size: 50,
                                    showName: false,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${profile?.stats.trophies ?? 0}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 18,
                                            color: AppTheme.textDark)),
                                    Text(profile?.stats.league ?? 'Bronze',
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.textLight)),
                                  ],
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ).animate().slideY(begin: 0.2, delay: 400.ms).fadeIn(),
                  ),
                  
                  const SizedBox(height: 15),

                  // XP & Coins Row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        _buildStatCard(
                            '${profile?.stats.xp ?? 0}',
                            'Total XP',
                            Icons.star,
                            const Color(0xFFFEF3C7),
                            const Color(0xFFF59E0B)),
                        const SizedBox(width: 15),
                        _buildStatCard(
                            '0',
                            'Lessons',
                            Icons.menu_book,
                            const Color(0xFFE0E7FF),
                            const Color(0xFF4F46E5)),
                        const SizedBox(width: 15),
                        _buildStatCard(
                            '${profile?.stats.coins ?? 0}',
                            'Coins',
                            Icons.monetization_on,
                            const Color(0xFFDCFCE7),
                            const Color(0xFF10B981)),
                      ],
                    ).animate().slideY(begin: 0.2, delay: 450.ms).fadeIn(),
                  ),

                  // Match history is handled differently now, omitting for now

                  // My Badges
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('My Badges',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.textDark)),
                    ),
                  ),
                  const SizedBox(height: 15),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    childAspectRatio: 0.8,
                    children: [
                      _buildBadge('Word Warrior', 'word_warrior', Colors.orange).animate().scale(delay: 500.ms),
                      _buildBadge('Math Master', 'math_master', Colors.blue).animate().scale(delay: 600.ms),
                      _buildBadge('Science Explorer', 'science_explorer', Colors.green).animate().scale(delay: 700.ms),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Friends list
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('My Friends (12 Online)',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.textDark)),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        _buildFriendItem(
                            'Luna', 'assets/images/avatars/alien.svg'),
                        _buildFriendItem(
                            'Orion', 'assets/images/avatars/astronaut.svg'),
                        _buildFriendItem(
                            'Comet', 'assets/images/avatars/robot.svg'),
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

  Widget _buildStatCard(String value, String label, IconData icon,
      Color bgColor, Color iconColor) {
    return Expanded(
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: bgColor.withValues(alpha: 0.5),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 35),
            const SizedBox(height: 8),
            Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    color: AppTheme.textDark)),
            Text(label,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textLight)),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String title, String svgName, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.1),
            ),
            child: SvgPicture.asset('assets/images/badges/$svgName.svg',
                height: 35,
                placeholderBuilder: (context) =>
                    Icon(Icons.military_tech, color: color, size: 35)),
          ),
          const SizedBox(height: 8),
          Text(title,
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, color: Color(0xFFFBBF24), size: 14),
              Icon(Icons.star, color: Color(0xFFFBBF24), size: 14),
              Icon(Icons.star, color: Color(0xFFFBBF24), size: 14),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildFriendItem(String name, String avatarPath) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                backgroundColor: AppTheme.pastelBlue,
                radius: 22,
                child: SvgPicture.asset(avatarPath,
                    width: 24,
                    placeholderBuilder: (context) =>
                        const Icon(Icons.person, color: Colors.blue)),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(name,
                style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: AppTheme.textDark)),
          ),
          IconButton(
            icon: const Icon(Icons.message, color: AppTheme.primaryBlue),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
