import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// The main Game class for Math Fun Drive using the Flame Engine.
/// Game Objective: Help Juno the octopus collect fuel bubbles by answering math questions.
class MathFunDriveGame extends FlameGame {
  late SpriteComponent junoTheOctopus;
  late TextComponent mathQuestion;
  int streak = 0; // Tracks consecutive correct answers for nitro booster

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 1. Load Background (Magic Cave)
    // TODO: Add scrolling parallax background for the cave

    // 2. Load Juno character
    // Using a placeholder rectangle until SVG/Sprite is available
    junoTheOctopus = SpriteComponent()
      ..size = Vector2(80, 80)
      ..position = Vector2(size.x / 4, size.y / 2)
      ..anchor = Anchor.center;
    // junoTheOctopus.sprite = await loadSprite('juno.png');

    // Fallback visually if sprite is missing
    add(RectangleComponent(
      size: Vector2(80, 80),
      position: Vector2(size.x / 4, size.y / 2),
      paint: Paint()..color = Colors.orange,
      anchor: Anchor.center,
    ));

    // 3. Load UI Overlay (The Math Question)
    mathQuestion = TextComponent(
      text: '2 + 3 = ?',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 32,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    )
      ..position = Vector2(size.x / 2, 50)
      ..anchor = Anchor.topCenter;

    add(mathQuestion);

    // 4. Spawn Bubbles (Options)
    spawnFuelBubbles();
  }

  void spawnFuelBubbles() {
    // Logic to spawn 3 bubbles with different numbers, one being the correct answer (5).
    // The player will have to tap or steer Juno to the correct bubble before the cave closes.
  }
}
