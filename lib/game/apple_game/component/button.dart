// lib/component/game_button.dart

import 'package:flame/events.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class GameButton extends PositionComponent with TapCallbacks {
  final String label;
  final VoidCallback onPressed;

  GameButton({
    required this.label,
    required this.onPressed,
    Vector2? position,
    Vector2? size,
  }) : super(
          position: position ?? Vector2.zero(),
          size: size ?? Vector2(100, 50),
        );

  @override
  Future<void> onLoad() async {
    debugMode = true;
    // 버튼의 배경 색상 및 스타일 설정
    final paint = Paint()..color = Colors.blue;
    add(RectangleComponent(
      size: size,
      paint: paint,
    ));

    add(TextComponent(
      text: label,
      position: Vector2(size.x / 2, size.y / 2),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      anchor: Anchor.center,
    ));
  }

  @override
  void onTapDown(TapDownEvent event) {
    onPressed();
    super.onTapDown(event);
  }
  // void onTapDown() {
  //   // 버튼 클릭 시 동작
  //   print('@@ Here ');

  // }
}
