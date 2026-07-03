import 'package:flutter/material.dart';

class MountainBackground extends StatelessWidget {
  const MountainBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 250,
      child: CustomPaint(
        painter: MountainPainter(),
      ),
    );
  }
}

class MountainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = const Color(0xFFE6E1FF).withValues(alpha: 0.5) // Pastel purple
      ..style = PaintingStyle.fill;

    final paint2 = Paint()
      ..color = const Color(0xFFF4F7FB)
          .withValues(alpha: 0.8) // Background light overlapping
      ..style = PaintingStyle.fill;

    // Draw background mountain
    final path1 = Path();
    path1.moveTo(0, size.height * 0.7);
    path1.quadraticBezierTo(size.width * 0.15, size.height * 0.4,
        size.width * 0.3, size.height * 0.6);
    path1.quadraticBezierTo(size.width * 0.5, size.height * 0.2,
        size.width * 0.7, size.height * 0.6);
    path1.quadraticBezierTo(
        size.width * 0.85, size.height * 0.3, size.width, size.height * 0.5);
    path1.lineTo(size.width, size.height);
    path1.lineTo(0, size.height);
    path1.close();

    canvas.drawPath(path1, paint1);

    // Draw foreground mountain
    final path2 = Path();
    path2.moveTo(0, size.height * 0.85);
    path2.quadraticBezierTo(size.width * 0.2, size.height * 0.5,
        size.width * 0.4, size.height * 0.75);
    path2.quadraticBezierTo(size.width * 0.65, size.height * 0.45,
        size.width * 0.9, size.height * 0.8);
    path2.lineTo(size.width, size.height * 0.8);
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();

    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
