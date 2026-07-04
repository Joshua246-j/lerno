import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

final animationManagerProvider = Provider<AnimationManager>((ref) {
  return AnimationManager();
});

class AnimationManager {
  // A centralized class to standardise animations across the app

  // Basic screen transition animations
  Widget fadeTransition(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  // Common micro-interactions
  Widget applyButtonPress(Widget child) {
    return child
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .scale(
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.05, 1.05),
            duration: 1.seconds);
  }

  // Success animations (e.g. correct answer)
  Widget applySuccessPop(Widget child) {
    return child
        .animate()
        .scale(
            begin: const Offset(0.8, 0.8),
            end: const Offset(1.1, 1.1),
            duration: 200.ms,
            curve: Curves.easeOutBack)
        .then()
        .scale(
            end: const Offset(1.0, 1.0),
            duration: 150.ms,
            curve: Curves.easeInOut);
  }

  // Error animations (e.g. wrong answer)
  Widget applyErrorShake(Widget child) {
    return child.animate().shake(hz: 4, duration: 400.ms);
  }

  // Coin collect animation
  Widget applyCoinCollect(Widget child) {
    return child
        .animate()
        .slideY(begin: 0.5, end: 0, duration: 400.ms, curve: Curves.easeOutBack)
        .fadeIn(duration: 400.ms)
        .then()
        .scale(
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.2, 1.2),
            duration: 200.ms)
        .then()
        .scale(
            begin: const Offset(1.2, 1.2),
            end: const Offset(1.0, 1.0),
            duration: 200.ms);
  }
}
