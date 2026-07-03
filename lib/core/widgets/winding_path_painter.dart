import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class WindingPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.3)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // We want a winding path from top to bottom
    path.moveTo(size.width * 0.5, 0);

    int nodes = 5;
    double segmentHeight = size.height / nodes;

    for (int i = 0; i < nodes; i++) {
      double startY = i * segmentHeight;
      double endY = (i + 1) * segmentHeight;

      // Control points for the bezier curve
      double cpX1 = (i % 2 == 0) ? size.width * 0.9 : size.width * 0.1;
      double cpX2 = (i % 2 == 0) ? size.width * 0.1 : size.width * 0.9;

      // Adjust start X based on current node
      double startX = (i == 0)
          ? size.width * 0.5
          : ((i % 2 == 0) ? size.width * 0.2 : size.width * 0.8);
      double endX = ((i + 1) % 2 == 0) ? size.width * 0.2 : size.width * 0.8;

      if (i == 0) {
        path.moveTo(startX, startY);
      }

      path.cubicTo(cpX1, startY + (segmentHeight * 0.3), cpX2,
          endY - (segmentHeight * 0.3), endX, endY);
    }

    // Draw dashed path
    Path dashPath = _createDashedPath(path);
    canvas.drawPath(dashPath, paint);
  }

  Path _createDashedPath(Path source) {
    const double dashLength = 10.0;
    const double dashSpace = 8.0;
    final Path dest = Path();
    for (final ui.PathMetric metric in source.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        dest.addPath(
          metric.extractPath(distance, distance + dashLength),
          Offset.zero,
        );
        distance += dashLength + dashSpace;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
