import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';

import 'package:flame/sprite.dart';

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_playground/game/watermellon_game/component/ball.dart';
import 'package:flame_playground/game/watermellon_game/component/ground.dart';
import 'package:flame_playground/game/watermellon_game/component/player.dart';

import 'component/background.dart';

class MyPhysicsGame extends Forge2DGame
    with TapCallbacks, HasCollisionDetection, HasGameRef<MyPhysicsGame> {
  MyPhysicsGame()
      : super(
          gravity: Vector2(0, 10),
          camera: CameraComponent.withFixedResolution(width: 300, height: 600),
          // contactListener: AABB(),
        );

  late final SpriteSheet aliens;
  late List<Sprite> ballImage;
  late final SpriteSheet tiles;

  @override
  FutureOr<void> onLoad() async {
    // debugMode = true;
    final backgroundImage = await images.load('colored_land.png');

    final al = await Flame.images.load('spritesheet_aliens.png');
    final ti = await Flame.images.load('spritesheet_tiles.png');
    aliens = SpriteSheet(image: al, srcSize: Vector2.all(70));
    ballImage = [
      aliens.getSprite(1, 0),
      aliens.getSprite(1, 1),
      aliens.getSprite(1, 3),
      aliens.getSprite(1, 4),
      aliens.getSprite(2, 4),
    ];
    tiles = SpriteSheet(image: ti, srcSize: Vector2.all(70));

    await world.add(Background(sprite: Sprite(backgroundImage)));
    await addGround();

    // await addPlayer();

    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if (!event.handled) {
      final touchPoint = camera.globalToLocal(event.devicePosition);
      // addPlayer(position: touchPoint);
      ball(position: touchPoint);
    }
  }

  Future<void> addGround() async {
    // Add from here...
    world.addAll([
      for (var x = camera.visibleWorldRect.left;
          x < camera.visibleWorldRect.right + groundSize;
          x += groundSize)
        Ground(
          Vector2(x, (camera.visibleWorldRect.height - groundSize) / 2),
          tiles.getSprite(1, 4),
        ),
    ]);

    world.addAll([
      for (var y = camera.visibleWorldRect.top;
          y < camera.visibleWorldRect.bottom + groundSize;
          y += groundSize)
        Ground(
          Vector2(camera.visibleWorldRect.left - 3, y),
          tiles.getSprite(1, 4),
        ),
    ]);
    world.addAll([
      for (var y = camera.visibleWorldRect.top;
          y < camera.visibleWorldRect.bottom + groundSize;
          y += groundSize)
        Ground(
          Vector2(camera.visibleWorldRect.right + 3, y),
          tiles.getSprite(1, 4),
        ),
    ]);

    return;
  }

  Future<void> addPlayer({
    required Vector2 position,
  }) async =>
      world.add(
        // Add from here...
        Player(
          position,
          ballImage[0],
        ),
      );

  Future<void> ball({
    required Vector2 position,
  }) async {
    double radius = Random().nextInt(3) + 2.0;
    world.add(
      Ball(
        position,
        radius: radius,
        spriteList: ballImage,
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    // if (isMounted && world.children.whereType<Player>().isEmpty) {
    // addPlayer();
    // }
  }

  void createPhysicsObject() {
    // 월드에서 물리적 객체를 만들기 위해, BodyDef를 정의합니다.
    final bodyDef = BodyDef()
      ..position = Vector2(100, 100) // 초기 위치 설정
      ..type = BodyType.dynamic; // 물리 엔진에서 움직이는 객체

    // 물리적 물체 생성
    final body = world.createBody(bodyDef);

    // 물리적 물체에 추가할 형상 정의 (여기서는 사각형)
    final shape = PolygonShape();
    shape.setAsBox(50, 50, Vector2(0, 0), 0); // 50x50 크기의 사각형

    // 물리적 형상 추가
    body.createFixtureFromShape(
      shape,
      density: 1.0,
    ); // 밀도 설정

    // Body를 화면에 표시할 SpriteComponent 추가
    final sprite = aliens.getSprite(1, 0); // 스프라이트 로딩
    final component = SpriteComponent()
      ..sprite = sprite
      ..size = Vector2(100, 100) // 크기 설정
      ..position = body.position; // Body의 위치와 맞추기

    add(component); // 화면에 추가
  }
}
