import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

const playerSize = 5.0;

class Player extends BodyComponent with ContactCallbacks {
  Player(Vector2 position, Sprite sprite)
      : _sprite = sprite,
        super(
          renderBody: false,
          bodyDef: BodyDef()
            ..position = position
            ..type = BodyType.dynamic
            ..angularDamping = 0.1
            ..linearDamping = 0.1,
          fixtureDefs: [
            FixtureDef(CircleShape()..radius = playerSize / 2)
              ..restitution = 0.4
              ..density = 0.75
              ..friction = 0.5
          ],
        );

  final Sprite _sprite;

  @override
  Future<void> onLoad() {
    // debugMode = true;
    addAll([
      SpriteComponent(
        anchor: Anchor.center,
        sprite: _sprite,
        size: Vector2(playerSize, playerSize),
        position: Vector2(0, 0),
      )
    ]);

    return super.onLoad();
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is Player) {}
    super.beginContact(other, contact);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // if (!body.isAwake) {
    //   removeFromParent();
    // }

    if (position.x > camera.visibleWorldRect.right + 10 ||
        position.x < camera.visibleWorldRect.left - 10) {
      removeFromParent();
    }
  }
}
