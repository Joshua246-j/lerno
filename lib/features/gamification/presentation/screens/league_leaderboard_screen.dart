import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lerno/core/models/user_model.dart';

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
      appBar: AppBar(
        title: Text('$currentLeague League'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildLeagueHeader(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Top 20% advance to the next league!',
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.blueAccent),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: leaderboard.length,
              itemBuilder: (context, index) {
                final user = leaderboard[index];
                final isPromotionZone =
                    index < (leaderboard.length * 0.2).ceil();

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isPromotionZone
                        ? Colors.green.withValues(alpha: 0.2)
                        : Colors.grey.shade200,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isPromotionZone ? Colors.green : Colors.black87,
                      ),
                    ),
                  ),
                  title: Text(
                    user.displayName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${user.stats.trophies}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.emoji_events,
                          color: Colors.amber, size: 20),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(delay: Duration(milliseconds: 50 * index))
                    .slideX();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeagueHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade900, Colors.blue.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.shield,
            size: 80,
            color: Colors.white70,
          ).animate().shimmer(duration: const Duration(seconds: 2)),
          const SizedBox(height: 8),
          Text(
            currentLeague.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}
