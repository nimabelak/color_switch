import 'dart:ui';
import 'package:firstgame/game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class Rotator extends PositionComponent with HasGameRef<MyGame> , CollisionCallbacks {
  static const String rotatorKey = 'rotator';
  final double thickness;
  final double rotationSpeed;

  Rotator(
      {required super.size,
      required super.position,
      this.thickness = 16.0,
      this.rotationSpeed = 2})
      : assert(size!.x == size.y),
        super(anchor: Anchor.center);

  @override
  void onLoad() {
    super.onLoad();
    int colorsLength = gameRef.colors.length;
    const circle = math.pi * 2;
    final sweep = circle / colorsLength;

    for (int i = 0; i < colorsLength; i++) {
      add(CircleArc(
          color: gameRef.colors[i], startAngle: i * sweep, sweepAngle: sweep));
    }
    add(
      RotateEffect.to(
        math.pi * 2,
        EffectController(speed: rotationSpeed, infinite: true),
      ),
    );

    
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}

class CircleArc extends PositionComponent with ParentIsA<Rotator> {
  final Color color;
  final double startAngle;
  final double sweepAngle;

  CircleArc(
      {required this.color, required this.startAngle, required this.sweepAngle})
      : super(anchor: Anchor.center);

  @override
  void onMount() {
    size = parent.size;
    position = size / 2;
    addPolygonHitbox();
    super.onMount();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawArc(
        size.toRect().deflate(parent.thickness / 2),
        startAngle,
        sweepAngle,
        false,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = parent.thickness);
    super.render(canvas);
  }

  void addPolygonHitbox() {
    final center = size / 2;
    final precision = 8;
    final segment = sweepAngle / (precision - 1);
    final radius = size.x / 2;
    List<Vector2> vertices = [];

   
      for (int i = 0; i < precision; i++) {
        final segmentStart = startAngle + segment * i;
        vertices.add(
          Vector2(math.cos(segmentStart + angle),
                      math.sin(segmentStart + angle)) *
                  radius +
              center,
        );
      }

      for (int i = precision - 1; i >= 0; i--) {
        final segmentStart = startAngle + segment * i;
        vertices.add(
          Vector2(math.cos(segmentStart + angle),
                      math.sin(segmentStart + angle)) *
                  (radius - 20) +
              center,
        );
      }
    

    add(
      PolygonHitbox(vertices, collisionType: CollisionType.passive),
    );
  }
}
