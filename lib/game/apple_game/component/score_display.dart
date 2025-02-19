import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ScoreDisplay extends PositionComponent {
  int score = 0;
  late final TextComponent label;
  late final TextComponent value;

  ScoreDisplay({
    Vector2? position,
  }) : super(position: position ?? Vector2.zero()) {
    // "Score" 레이블 (위쪽에 표시)
    label = TextComponent(
      text: 'Score',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      anchor: Anchor.topCenter,
    );
    // 점수 숫자 (아래에 표시)
    value = TextComponent(
      text: '0',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.black,
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),
      ),
      anchor: Anchor.topCenter,
    );

    add(label);
    add(value);

    // 내부 배치: label은 컴포넌트 상단 중앙, value는 그 아래쪽에 배치
    label.position = Vector2(-20, -280);
    value.position = Vector2(-20, -250);

    // 임시로 ScoreDisplay의 배경색을 넣어 디버깅(이후 제거 가능)
    debugMode = false;
  }

  void addScore(int delta) {
    score += delta;
    value.text = score.toString();
  }
}