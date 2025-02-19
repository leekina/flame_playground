import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_playground/game/apple_game/component/apple.dart';

import 'package:flutter/material.dart';

class DragArea extends PositionComponent
    with CollisionCallbacks, DragCallbacks {
  final _collisionStartColor = Colors.amber;

  int sum = 0;
  late ShapeHitbox hitbox;

  DragArea()
      : super(
          position: Vector2(0, 0),
          size: Vector2(300, 300),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    debugMode = true;
  }

  Vector2 _dragStart = Vector2.zero();
  Vector2 _dragDelta = Vector2.zero();
  Vector2 get dragDelta => _dragDelta;

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    _dragStart = event.localPosition;
    add(
      CustomPainterComponent(
        painter: _DragPainter(this),
        anchor: Anchor.center,
        position: _dragStart,
      ),
    );
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    // print('@@ Here drag update');
    // print('@@ Here ${_dragDelta.x} / ${_dragDelta.y}');
    _dragDelta = event.localEndPosition - _dragStart;
  }

  Vector2 calcPosition() {
    if (_dragDelta.x < 0 && _dragDelta.y < 0) {
      return _dragStart + _dragDelta;
    }
    if (_dragDelta.x < 0) {
      return Vector2(_dragStart.x + _dragDelta.x, _dragStart.y);
    }
    if (_dragDelta.y < 0) {
      return Vector2(_dragStart.x, _dragStart.y + _dragDelta.y);
    }
    return _dragStart;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    // print('@@ Here end');

    super.onDragEnd(event);
    hitbox = RectangleHitbox(
      position: calcPosition(),
      size: Vector2(_dragDelta.x.abs(), _dragDelta.y.abs()),
      anchor: Anchor.topLeft,
      isSolid: true,
    );
    add(hitbox);

    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        children
            .whereType<CustomPainterComponent>()
            .firstOrNull
            ?.removeFromParent();
        children.whereType<RectangleHitbox>().firstOrNull?.removeFromParent();
      },
    );
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Apple) {
      sum += other.value;
      // print('@@ Here ${other.value}');
    }
    hitbox.paint.color = _collisionStartColor;
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (sum == 10) {
      // print('@@ Here ${sum}');
      other.removeFromParent();
    }
    if (!isColliding) {
      sum = 0;
      // print('@@ Here ${sum}');
    }
  }
}

class _DragPainter extends CustomPainter {
  _DragPainter(this.box);

  final DragArea box;

  @override
  void paint(Canvas canvas, Size size) {
    if (box.dragDelta != Vector2.zero()) {
      var center = size.center(Offset.zero);
      canvas.drawRect(
        Rect.fromPoints(
          center,
          center + (box.dragDelta).toOffset(),
        ),
        Paint()
          ..color = Colors.amber.withOpacity(0.8)
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
      );
      canvas.drawRect(
        Rect.fromPoints(
          center,
          center + (box.dragDelta).toOffset(),
        ),
        Paint()
          ..color = Colors.amber.withOpacity(0.5)
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DragPainter2 extends PositionComponent with CollisionCallbacks {
  final DragArea box;
  final Vector2 dargStart;

  DragPainter2(this.box, this.dargStart);
  bool isColl = false;
  Color color = Colors.amber;

  @override
  void render(Canvas canvas) {
    if (box.dragDelta != Vector2.zero()) {
      var center = dargStart.toOffset();

      canvas.drawRect(
        Rect.fromPoints(
          center,
          center + (box.dragDelta).toOffset(),
        ),
        Paint()
          ..color = Colors.amber.withOpacity(0.8)
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
      );
      canvas.drawRect(
        Rect.fromPoints(
          center,
          center + (box.dragDelta).toOffset(),
        ),
        Paint()
          ..color = Colors.amber.withOpacity(0.5)
          ..style = PaintingStyle.fill,
      );
    }
    super.render(canvas);
  }

  Vector2 calcPosition() {
    if (box.dragDelta.x < 0 && box.dragDelta.y < 0) {
      return dargStart + box.dragDelta;
    }
    if (box.dragDelta.x < 0) {
      return Vector2(dargStart.x + box.dragDelta.x, dargStart.y);
    }
    if (box.dragDelta.y < 0) {
      return Vector2(dargStart.x, dargStart.y + box.dragDelta.y);
    }
    return dargStart;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Apple) {
      print('@@ Here ');
    }
    isColl = true;
  }

  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
