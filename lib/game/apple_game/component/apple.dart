import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/widgets.dart';

class Apple extends PositionComponent with CollisionCallbacks {
  int value;
  late SpriteComponent _spriteComponent;
  late Sprite _normalSprite;
  late Sprite _selectedSprite;
  bool _isSelected = false;
  
  bool get isSelected => _isSelected;

  Apple({
    required this.value,
    required Vector2 position,
  }) : super(
          anchor: Anchor.center,
          position: position,
        );

  @override
  FutureOr<void> onLoad() async {
    _normalSprite = Sprite(await Flame.images.load('apple.png'));
    _selectedSprite = Sprite(await Flame.images.load('apple_select.png'));
    
    _spriteComponent = SpriteComponent(
      anchor: Anchor.center,
      sprite: _normalSprite,
      size: Vector2(24, 24),
      position: Vector2(0, 0),
    );

    addAll([
      _spriteComponent,
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

  void setSelected(bool selected) {
    if (_isSelected != selected) {
      _isSelected = selected;
      _spriteComponent.sprite = selected ? _selectedSprite : _normalSprite;
    }
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
