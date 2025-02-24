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
  late TextComponent _textComponent; // 텍스트 컴포넌트 추가

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
      size: Vector2(28, 28),
      position: Vector2(0, 0),
    );

    _textComponent = TextComponent(
      text: value.toString(),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(0, 3),
    );

    addAll([
      _spriteComponent,
      _textComponent, // 텍스트 컴포넌트 추가
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

  void updateValue(int newValue) {
    value = newValue;
    _textComponent.text = value.toString(); // 텍스트 업데이트
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
