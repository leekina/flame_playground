import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame_playground/game/apple_game/component/apple.dart';
import 'package:flame_playground/game/apple_game/component/score_display.dart';
import 'package:flutter/material.dart';

class DragArea extends PositionComponent
    with CollisionCallbacks, DragCallbacks {
  int sum = 0;
  DragPainter2? currentDragBox;

  DragArea()
      : super(
          position: Vector2(0, 0),
          size: Vector2(300, 300),
          anchor: Anchor.center,
        );

  Vector2 _dragStart = Vector2.zero();
  Vector2 _dragDelta = Vector2.zero();

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    currentDragBox?.removeFromParent();

    _dragStart = event.localPosition;
    _dragDelta = Vector2.zero();
    sum = 0;

    currentDragBox = DragPainter2(this, _dragStart);
    add(currentDragBox!);

    parent?.children.query<Apple>().forEach((apple) {
      apple.setSelected(false);
    });
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    _dragDelta = event.localStartPosition - _dragStart;
    if (currentDragBox != null) {
      final rect = _getSelectionRect();
      _updateAppleSelection(rect);
    }
  }

  Rect _getSelectionRect() {
    final localTopLeftGlobal = absolutePosition - (size / 2);
    final globalDragStart = localTopLeftGlobal + _dragStart;
    final globalDragEnd = localTopLeftGlobal + (_dragStart + _dragDelta);

    final left = min(globalDragStart.x, globalDragEnd.x).toDouble();
    final top = min(globalDragStart.y, globalDragEnd.y).toDouble();
    final right = max(globalDragStart.x, globalDragEnd.x).toDouble();
    final bottom = max(globalDragStart.y, globalDragEnd.y).toDouble();

    return Rect.fromLTRB(left, top, right, bottom);
  }

  void _updateAppleSelection(Rect selectionRect) {
    parent?.children.query<Apple>().forEach((apple) {
      final applePos = apple.absolutePosition;
      final appleRect = Rect.fromCenter(
        center: Offset(applePos.x, applePos.y),
        width: apple.size.x.toDouble(),
        height: apple.size.y.toDouble(),
      );

      final isOverlapping = selectionRect.overlaps(appleRect);

      if (isOverlapping && !apple.isSelected) {
        apple.setSelected(true);
        sum += apple.value;
      } else if (!isOverlapping && apple.isSelected) {
        apple.setSelected(false);
        sum -= apple.value;
      }
    });
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    
    final List<Apple> selectedApples = parent?.children
        .query<Apple>()
        .where((apple) => apple.isSelected)
        .toList() ?? [];
    
    if (sum == 10) {
      final Random rand = Random();
      
      for (final apple in selectedApples) {
        final double randomX = (rand.nextDouble() * 50) * (rand.nextBool() ? 1 : -1);
        final double randomYJump = -(30 + rand.nextDouble() * 40);
        
        final jumpEffect = MoveByEffect(
          Vector2(randomX * 0.5, randomYJump),
          EffectController(duration: 0.2, curve: Curves.easeOut),
        );
        
        final fallEffect = MoveByEffect(
          Vector2(randomX, 600),
          EffectController(duration: 0.5, curve: Curves.easeIn),
          onComplete: () => apple.removeFromParent(),
        );
        
        final sequenceEffect = SequenceEffect([jumpEffect, fallEffect]);
        apple.add(sequenceEffect);
      }
      
      final scoreDisplays = parent?.children.query<ScoreDisplay>();
      if (scoreDisplays != null && scoreDisplays.isNotEmpty) {
        scoreDisplays.first.addScore(selectedApples.length);
      }
    }
    
    currentDragBox?.removeFromParent();
    currentDragBox = null;
    
    Future.delayed(const Duration(milliseconds: 500), () {
      sum = 0;
      parent?.children.query<Apple>().forEach((apple) {
        apple.setSelected(false);
      });
    });
  }
}

class DragPainter2 extends PositionComponent {
  final DragArea box;
  final Vector2 dragStart;

  DragPainter2(this.box, this.dragStart) : super() {
    anchor = Anchor.topLeft;
  }

  @override
  void render(Canvas canvas) {
    if (box._dragDelta != Vector2.zero()) {
      final endPoint = dragStart + box._dragDelta;

      final left = min(dragStart.x, endPoint.x).toDouble();
      final top = min(dragStart.y, endPoint.y).toDouble();
      final right = max(dragStart.x, endPoint.x).toDouble();
      final bottom = max(dragStart.y, endPoint.y).toDouble();

      position = Vector2(left, top);
      size = Vector2(right - left, bottom - top);

      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.x, size.y),
        Paint()
          ..color = Colors.blue.withOpacity(0.2)
          ..style = PaintingStyle.fill,
      );
    }
    super.render(canvas);
  }
}
