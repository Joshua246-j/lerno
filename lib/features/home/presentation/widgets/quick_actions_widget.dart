import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lerno/core/theme/app_theme.dart';
import 'package:lerno/core/audio/audio_manager.dart';

class QuickAction {
  final String label;
  final IconData icon;
  final Color color;
  final String route;

  const QuickAction({
    required this.label,
    required this.icon,
    required this.color,
    required this.route,
  });
}

const List<QuickAction> _actions = [
  QuickAction(
      label: 'Missions',
      icon: Icons.task_alt,
      color: Color(0xFF10B981),
      route: '/daily_missions'),
  QuickAction(
      label: 'Leaderboard',
      icon: Icons.leaderboard,
      color: Color(0xFFF59E0B),
      route: '/leaderboard'),
  QuickAction(
      label: 'Inbox',
      icon: Icons.inbox,
      color: Color(0xFF3B82F6),
      route: '/inbox'),
  QuickAction(
      label: 'Friends',
      icon: Icons.people,
      color: Color(0xFF8B5CF6),
      route: '/friends'),
  QuickAction(
      label: 'Search',
      icon: Icons.search,
      color: Color(0xFF6366F1),
      route: '/search'),
];

class QuickActionsWidget extends ConsumerWidget {
  const QuickActionsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text('Quick Actions',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark)),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            itemCount: _actions.length,
            itemBuilder: (context, index) {
              final action = _actions[index];
              return GestureDetector(
                onTap: () {
                  ref.read(audioManagerProvider).playClick();
                  context.push(action.route);
                },
                child: Container(
                  width: 80,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: action.color.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(action.icon, color: action.color, size: 28),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        action.label,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textDark),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
