import 'package:flutter/material.dart';
import '../../domain/models/league_system.dart';
import 'package:lerno/core/theme/app_theme.dart';

class LeagueShieldWidget extends StatelessWidget {
  final LeagueTier league;
  final double size;
  final bool showName;

  const LeagueShieldWidget({
    super.key,
    required this.league,
    this.size = 100,
    this.showName = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size * 1.1,
          child: CustomPaint(
            painter: _ShieldPainter(color: league.color),
            child: Center(
              child: Icon(
                _getIconForLeague(league),
                color: Colors.white,
                size: size * 0.5,
              ),
            ),
          ),
        ),
        if (showName) ...[
          const SizedBox(height: 8),
          Text(
            league.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: size * 0.16,
              color: AppTheme.textDark,
            ),
          ),
        ],
      ],
    );
  }

  IconData _getIconForLeague(LeagueTier league) {
    if (league.name.contains('Bronze')) return Icons.star_border;
    if (league.name.contains('Silver')) return Icons.star_half;
    if (league.name.contains('Gold')) return Icons.star;
    if (league.name.contains('Crystal')) return Icons.diamond_outlined;
    if (league.name.contains('Master')) return Icons.diamond;
    if (league.name.contains('Champion')) return Icons.military_tech;
    return Icons.workspace_premium;
  }
}

class _ShieldPainter extends CustomPainter {
  final Color color;

  _ShieldPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width / 2, 0); // Top center
    path.lineTo(size.width, size.height * 0.2); // Top right
    path.lineTo(size.width, size.height * 0.6); // Right edge goes down
    // Curve to bottom center
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width / 2, size.height);
    // Curve to left edge
    path.quadraticBezierTo(size.width / 2, size.height, 0, size.height * 0.6);
    path.lineTo(0, size.height * 0.2); // Left edge goes up
    path.close();

    // Add shadow
    canvas.drawShadow(path, color.withValues(alpha: 0.5), 8, true);

    canvas.drawPath(path, paint);

    // Add border
    final borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawPath(path, borderPaint);

    // Add inner highlight
    final highlightPath = Path();
    highlightPath.moveTo(size.width / 2, size.height * 0.05);
    highlightPath.lineTo(size.width * 0.9, size.height * 0.22);
    highlightPath.lineTo(size.width * 0.9, size.height * 0.58);
    highlightPath.quadraticBezierTo(
        size.width / 2, size.height * 0.92, size.width / 2, size.height * 0.92);
    highlightPath.quadraticBezierTo(size.width / 2, size.height * 0.92,
        size.width * 0.1, size.height * 0.58);
    highlightPath.lineTo(size.width * 0.1, size.height * 0.22);
    highlightPath.close();

    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;
    canvas.drawPath(highlightPath, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
