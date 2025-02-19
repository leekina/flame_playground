import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_playground/game/apple_game/game.dart';

class Background extends SpriteComponent with HasGameReference<AppleGame> {
  Background({required super.sprite})
      : super(
          anchor: Anchor.center,
          position: Vector2(0, 0),
        );

  @override
  void onMount() {
    super.onMount();

    size = Vector2.all(max(
      game.camera.visibleWorldRect.width,
      game.camera.visibleWorldRect.height,
    ));
  }
}
