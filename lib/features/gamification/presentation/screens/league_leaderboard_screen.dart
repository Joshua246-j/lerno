import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lerno/core/models/user_model.dart';
import 'package:lerno/core/theme/app_theme.dart';
import 'package:lerno/core/theme/app_assets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LeagueLeaderboardScreen extends StatelessWidget {
  final String currentLeague;
  final List<UserModel> leaderboard;

  const LeagueLeaderboardScreen({
    super.key,
    required this.currentLeague,
    required this.leaderboard,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: Text('$currentLeague League', style: const TextStyle(fontWeight: FontWeight.w900, color: AppTheme.textDark)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.textDark),
      ),
      body: Column(
        children: [
          _buildPodium(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.blueAccent),
                SizedBox(width: 8),
                Text(
                  'Top 20% advance to the next league!',
                  style: TextStyle(
                      fontWeight: FontWeight.w800, color: Colors.blueAccent, fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: leaderboard.length > 3 ? leaderboard.length - 3 : 0,
              itemBuilder: (context, index) {
                final user = leaderboard[index + 3];
                final actualRank = index + 4;
                final isPromotionZone = actualRank <= (leaderboard.length * 0.2).ceil();

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: isPromotionZone ? Colors.green.withValues(alpha: 0.3) : Colors.transparent, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: isPromotionZone ? Colors.green.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ]
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isPromotionZone ? Colors.green.withValues(alpha: 0.1) : Colors.grey.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '$actualRank',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                              color: isPromotionZone ? Colors.green : AppTheme.textDark,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppTheme.pastelPurple,
                        child: SvgPicture.asset(AppAssets.getAvatarPath(user.avatarId), width: 26),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          user.displayName,
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppTheme.textDark),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${user.stats.trophies}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 14, color: Colors.amber),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.emoji_events, color: Colors.amber, size: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: Duration(milliseconds: 50 * index)).slideX(begin: 0.1);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodium() {
    if (leaderboard.length < 3) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 10, bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildPodiumPlace(leaderboard[1], 2, 110, const Color(0xFFE2E8F0)), // Silver
          const SizedBox(width: 10),
          _buildPodiumPlace(leaderboard[0], 1, 140, const Color(0xFFFBBF24)), // Gold
          const SizedBox(width: 10),
          _buildPodiumPlace(leaderboard[2], 3, 90, const Color(0xFFFDBA74)),  // Bronze
        ],
      ),
    );
  }

  Widget _buildPodiumPlace(UserModel user, int rank, double height, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 15),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 4),
                boxShadow: [
                  BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 15, offset: const Offset(0, 5))
                ]
              ),
              child: CircleAvatar(
                radius: rank == 1 ? 40 : 32,
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SvgPicture.asset(AppAssets.getAvatarPath(user.avatarId)),
                ),
              ),
            ),
            if (rank == 1)
              const Positioned(
                top: 0,
                child: Icon(Icons.workspace_premium, color: Colors.amber, size: 32),
              ),
          ],
        ).animate().scale(delay: Duration(milliseconds: rank * 200)),
        const SizedBox(height: 10),
        Text(user.displayName.split(" ")[0], style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textDark, fontSize: 14)),
        const SizedBox(height: 5),
        Container(
          width: rank == 1 ? 100 : 80,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            boxShadow: [
              BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 10, offset: const Offset(0, -2))
            ]
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('$rank', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: Colors.white)),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${user.stats.trophies}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  const Icon(Icons.emoji_events, color: Colors.white, size: 14),
                ],
              )
            ],
          ),
        ).animate().slideY(begin: 1.0, curve: Curves.easeOutBack, duration: 600.ms)
      ],
    );
  }
}
