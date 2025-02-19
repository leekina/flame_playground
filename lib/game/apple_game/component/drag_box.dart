// import 'package:flame/collisions.dart';
// import 'package:flame/components.dart';

// import 'package:flutter/material.dart';

// class DragBox extends PositionComponent with CollisionCallbacks {
//   final _collisionStartColor = Colors.amber;
//   final _defaultColor = Colors.cyan;
//   late ShapeHitbox hitbox;

//   DragBox(Vector2 start, Vector2 position)
//       : super(
//           position: start,
//           size: position,
//           anchor: Anchor.center,
//         );

//   @override
//   Future<void> onLoad() async {
//     final defaultPaint = Paint()
//       ..color = Colors.orange.withOpacity(0.8)
//       ..strokeWidth = 2
//       ..strokeCap = StrokeCap.round
//       ..style = PaintingStyle.stroke;
//     hitbox = RectangleHitbox()
//       ..paint = defaultPaint
//       ..renderShape = true;

//     add(hitbox);
//   }

//   // @override
//   // void onDragStart(DragStartEvent event) {
//   //   super.onDragStart(event);
//   //   print('@@ Here start2');
//   //   // add(
//   //   //   CustomPainterComponent(
//   //   //     painter: _DragPainter(this),
//   //   //     anchor: Anchor.center,
//   //   //     position: Vector2(0, 0),
//   //   //   ),
//   //   // );
//   //   _dragStart = event.localPosition;
//   // }

//   // @override
//   // void onDragUpdate(DragUpdateEvent event) {
//   //   print('@@ Here drag update2');
//   //   _dragDelta = event.localEndPosition - _dragStart;
//   // }

//   // @override
//   // void onDragEnd(DragEndEvent event) {
//   //   print('@@ Here end2');
//   //   super.onDragEnd(event);
//   //   children
//   //       .whereType<CustomPainterComponent>()
//   //       .firstOrNull
//   //       ?.removeFromParent();
//   //   // add(RemoveEffect(
//   //   //   delay: 5.0,
//   //   // ));
//   // }

//   Vector2 _dragStart = Vector2.zero();
//   Vector2 _dragDelta = Vector2.zero();
//   Vector2 get dragDelta => _dragDelta;

//   @override
//   void onCollision(
//     Set<Vector2> intersectionPoints,
//     PositionComponent other,
//   ) {
//     super.onCollision(intersectionPoints, other);
//   }

//   @override
//   void onCollisionStart(
//     Set<Vector2> intersectionPoints,
//     PositionComponent other,
//   ) {
//     super.onCollisionStart(intersectionPoints, other);
//     hitbox.paint.color = _collisionStartColor;
//   }

//   @override
//   void onCollisionEnd(PositionComponent other) {
//     super.onCollisionEnd(other);
//     if (!isColliding) {
//       hitbox.paint.color = _defaultColor;
//     }
//   }
// }

// class _DragPainter extends CustomPainter {
//   _DragPainter(this.box);

//   final DragBox box;

//   @override
//   void paint(Canvas canvas, Size size) {
//     if (box.dragDelta != Vector2.zero()) {
//       var center = size.center(Offset.zero);
//       canvas.drawRect(
//         Rect.fromPoints(
//           center,
//           center + (box.dragDelta).toOffset(),
//         ),
//         Paint()
//           ..color = Colors.orange.withOpacity(0.8)
//           ..strokeWidth = 2
//           ..strokeCap = StrokeCap.round
//           ..style = PaintingStyle.stroke,
//       );
//       canvas.drawRect(
//         Rect.fromPoints(
//           center,
//           center + (box.dragDelta).toOffset(),
//         ),
//         Paint()
//           ..color = Colors.orange.withOpacity(0.5)
//           ..style = PaintingStyle.fill,
//       );
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }
