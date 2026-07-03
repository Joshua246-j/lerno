import 'package:flutter/material.dart';
import 'package:lerno/core/theme/app_theme.dart';

class CountdownTimer extends StatelessWidget {
  final int secondsRemaining;
  final int totalSeconds;

  const CountdownTimer({
    super.key,
    required this.secondsRemaining,
    required this.totalSeconds,
  });

  @override
  Widget build(BuildContext context) {
    final progress = secondsRemaining / totalSeconds;
    final color = progress > 0.3 ? AppTheme.pastelGreen : Colors.redAccent;

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade200,
            color: color,
            strokeWidth: 6,
          ),
          Center(
            child: Text(
              '$secondsRemaining',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: progress > 0.3 ? AppTheme.textDark : Colors.redAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
