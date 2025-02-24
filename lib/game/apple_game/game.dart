import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_playground/game/apple_game/component/apple.dart';
import 'package:flame_playground/game/apple_game/component/background.dart';
import 'package:flame_playground/game/apple_game/component/button.dart';
import 'package:flame_playground/game/apple_game/component/drag_box_v2.dart';
import 'package:flame_playground/game/apple_game/component/score_display.dart';

class AppleGame extends FlameGame
    with HasCollisionDetection, DragCallbacks, HasGameRef<AppleGame> {
  AppleGame()
      : super(
          camera: CameraComponent.withFixedResolution(width: 300, height: 600),
        );

  final List<Apple> apples = [];

  @override
  FutureOr<void> onLoad() async {
    // debugMode = true;
    final backgroundImage = await images.load('colored_land.png');

    world.addAll(
      [
        Background(sprite: Sprite(backgroundImage)),
        DragArea(onApplesRemoved: handleApplesRemoved),
        ScoreDisplay(position: Vector2(20, 20)),
      ],
    );
    addApple();

    final gameButton = GameButton(
      label: 'Reroll',
      onPressed: changeAppleValues,
      position: Vector2(-130, 200), // 버튼 위치
    );
    world.add(gameButton);
    final gameButton2 = GameButton(
      label: 'Reset',
      onPressed: addApple,
      position: Vector2(20, 200), // 버튼 위치
    );
    world.add(gameButton2);
  }

  void handleApplesRemoved(List<Apple> removedApples) {
    for (var apple in removedApples) {
      apples.remove(apple); // 리스트에서 삭제된 사과 제거
    }
    print('Removed apples: ${removedApples.length}');
  }

  void changeAppleValues() {
    for (var apple in apples) {
      int newValue = (apple.value % 8) + 1; // 사과 값을 1~8 사이로 변경
      apple.updateValue(newValue); // 텍스트 업데이트
    }
    print('All apple values changed!');
  }

  Future<void> addApple() async {
    for (var apple in apples) {
      world.remove(apple);
    }
    apples.clear(); // 리스트 초기화

    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        double x = i * 34.0;
        double y = j * 34.0;
        final apple = Apple(
          value: Random().nextInt(8) + 1,
          position: Vector2(x - 120, y - 120),
        );
        apples.add(apple);
        world.add(apple);
      }
    }

    return;
  }
}
