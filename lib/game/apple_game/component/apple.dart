import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/widgets.dart';

class Apple extends PositionComponent with CollisionCallbacks {
  int value;

  Apple({
    required this.value,
    required Vector2 position,
  }) : super(
          anchor: Anchor.center,
          position: position,
        );

  @override
  FutureOr<void> onLoad() async {
    final apple = await Flame.images.load('apple.png');
    final apple2 = await Flame.images.load('apple_select.png');
    addAll([
      SpriteComponent(
        anchor: Anchor.center,
        sprite: Sprite(apple),
        size: Vector2(24, 24),
        position: Vector2(0, 0),
      ),
      TextComponent(
        text: value.toString(),
        textRenderer: TextPaint(
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        anchor: Anchor.center,
        position: Vector2(0, 3),
      ),
      RectangleHitbox(
        position: Vector2(0, 0),
        size: Vector2(12, 12),
        anchor: Anchor.center,
      ),
    ]);

    return super.onLoad();
  }

  // @override
  // void onCollisionStart(
  //     Set<Vector2> intersectionPoints, PositionComponent other) {
  //   super.onCollisionStart(intersectionPoints, other);
  // }

  // @override
  // void onCollisionEnd(PositionComponent other) {
  //   // TODO: implement onCollisionEnd
  //   super.onCollisionEnd(other);
  // }
}
