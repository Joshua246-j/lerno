import 'package:flutter/material.dart';
import 'package:lerno/core/theme/app_theme.dart';

class FriendProfileScreen extends StatelessWidget {
  final String friendName;
  final String friendLeague;
  final int friendTrophies;

  const FriendProfileScreen({
    super.key,
    required this.friendName,
    required this.friendLeague,
    required this.friendTrophies,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Profile',
            style: TextStyle(
                color: AppTheme.textDark, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.textDark),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Avatar Placeholder
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.orangeAccent,
              child: Icon(Icons.cruelty_free,
                  size: 60, color: Colors.white), // Octopus placeholder
            ),
            const SizedBox(height: 15),
            Text(
              friendName,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark),
            ),
            Text(
              'League: $friendLeague',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // Stats Board
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.blue.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('Trophies', friendTrophies.toString(),
                      Icons.emoji_events, Colors.amber),
                  Container(height: 40, width: 1, color: Colors.grey.shade200),
                  _buildStatItem('Streak', '12', Icons.local_fire_department,
                      Colors.orange),
                  Container(height: 40, width: 1, color: Colors.grey.shade200),
                  _buildStatItem('Badges', '5', Icons.shield, Colors.blue),
                ],
              ),
            ),

            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.sports_esports),
              label: const Text('Challenge to 1v1 Battle'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 5),
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}
