import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_playground/game/apple_game/component/apple.dart';
import 'package:flame_playground/game/apple_game/component/background.dart';
import 'package:flame_playground/game/apple_game/component/drag_box_v2.dart';
import 'package:flame_playground/game/apple_game/component/score_display.dart';

class AppleGame extends FlameGame
    with HasCollisionDetection, DragCallbacks, HasGameRef<AppleGame> {
  AppleGame()
      : super(
          camera: CameraComponent.withFixedResolution(width: 300, height: 600),
        );
  //사과 25개띄움
  //드래그 시작지점부터 드래그 끝 지점까지 상자만듬
  //드래그 끝날때 상자와 충돌된 사과 값 다 더해서 10 되면 삭제

  @override
  FutureOr<void> onLoad() async {
    // debugMode = true;
    final backgroundImage = await images.load('colored_land.png');

    world.addAll(
      [
        Background(sprite: Sprite(backgroundImage)),
        DragArea(),
        ScoreDisplay(position: Vector2(20, 20)),
      ],
    );
    addApple();
  }

  Future<void> addApple() async {
    // Add from here...

    for (int i = 0; i < 10; i++) {
      for (int j = 0; j < 10; j++) {
        double x = i * 28.0;
        double y = j * 28.0;
        world.add(
          Apple(
            value: Random().nextInt(8) + 1,
            position: Vector2(x - 130, y - 130),
          ),
        );
      }
    }

    return;
  }
}
