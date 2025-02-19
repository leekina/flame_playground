import 'package:flame/components.dart';

import 'package:flame/palette.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class Ball extends BodyComponent with ContactCallbacks {
  late Paint originalPaint;
  bool giveNudge = false;
  final double radius;
  final BodyType bodyType;
  final Vector2 _position;
  double _timeSinceNudge = 0.0;
  static const double _minNudgeRest = 2.0;
  final List<Sprite> spriteList;

  final Paint _blue = BasicPalette.blue.paint();

  Ball(
    this._position, {
    this.radius = 2,
    this.bodyType = BodyType.dynamic,
    Color? color,
    required this.spriteList,
  }) {
    if (color != null) {
      originalPaint = PaletteEntry(color).paint();
    } else {
      originalPaint = randomPaint();
    }
    paint = originalPaint;
  }

  Paint randomPaint() => PaintExtension.random(withAlpha: 0.9, base: 100);

  @override
  Future<void> onLoad() {
    int rad = radius.toInt() - 2;
    addAll([
      SpriteComponent(
        anchor: Anchor.center,
        sprite: spriteList[rad],
        size: Vector2(radius * 2, radius * 2),
        position: Vector2(0, 0),
      )
    ]);
    return super.onLoad();
  }

  @override
  Body createBody() {
    final shape = CircleShape();
    shape.radius = radius;

    final fixtureDef = FixtureDef(
      shape,
      restitution: 0.8,
      friction: 0.4,
    );

    final bodyDef = BodyDef(
      userData: this,
      angularDamping: 0.8,
      position: _position,
      type: bodyType,
    );

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void renderCircle(Canvas canvas, Offset center, double radius) {
    super.renderCircle(canvas, center, radius);
    final lineRotation = Offset(0, radius);
    canvas.drawLine(center, center + lineRotation, _blue);
  }

  final _impulseForce = Vector2(0, 1000);

  @override
  @mustCallSuper
  void update(double dt) {
    _timeSinceNudge += dt;
    if (giveNudge) {
      giveNudge = false;
      if (_timeSinceNudge > _minNudgeRest) {
        body.applyLinearImpulse(_impulseForce);
        _timeSinceNudge = 0.0;
      }
    }
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is Ball && other.radius == radius) {
      removeFromParent();

      if (paint != originalPaint) {
        world.add(
          Ball(
            calculateMidpoint(position, other.position),
            radius: radius + 1,
            spriteList: spriteList,
          ),
        );
        paint = other.paint;
      } else {
        other.paint = paint;
      }
    }
  }

  Vector2 calculateMidpoint(Vector2 v1, Vector2 v2) {
    // 각 성분의 중간값을 계산합니다.
    double midX = (v1.x + v2.x) / 2;
    double midY = (v1.y + v2.y) / 2;

    // Vector2 객체를 생성하여 반환합니다.
    return Vector2(midX, midY);
  }
}
