import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lerno/core/theme/app_theme.dart';
import 'package:lerno/core/audio/audio_service.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AchievementPopup extends StatefulWidget {
  final String title;
  final String subtitle;
  final AudioService audioService;

  const AchievementPopup({
    super.key,
    required this.title,
    required this.subtitle,
    required this.audioService,
  });

  static Future<void> show(
      BuildContext context, String title, String subtitle, AudioService audio) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (context) => AchievementPopup(
          title: title, subtitle: subtitle, audioService: audio),
    );
  }

  @override
  State<AchievementPopup> createState() => _AchievementPopupState();
}

class _AchievementPopupState extends State<AchievementPopup> {
  @override
  void initState() {
    super.initState();
    // Play sound effect when popup opens
    widget.audioService.playVictoryChime();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withValues(alpha: 0.3),
              blurRadius: 30,
              spreadRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // SVG Animation
            SizedBox(
              height: 120,
              child: SvgPicture.asset(
                'assets/images/juno.svg',
                placeholderBuilder: (context) =>
                    const CircularProgressIndicator(),
              ).animate().scale(
                  delay: 200.ms, duration: 400.ms, curve: Curves.elasticOut),
            ),
            const SizedBox(height: 20),

            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppTheme.primaryBlue,
              ),
              textAlign: TextAlign.center,
            ).animate().fade(delay: 400.ms).slideY(begin: 0.5),

            const SizedBox(height: 10),

            Text(
              widget.subtitle,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ).animate().fade(delay: 600.ms),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                widget.audioService.playButtonTap();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Awesome!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ).animate().scale(delay: 800.ms, curve: Curves.elasticOut),
          ],
        ),
      )
          .animate()
          .fadeIn(duration: 300.ms)
          .scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack),
    );
  }
}
