import 'dart:ui';
import 'dart:math' as math;
import 'package:firstgame/game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

class ColorSwitcher extends PositionComponent
    with HasGameRef<MyGame>, CollisionCallbacks {
  final double radius;
  late Sprite sprite;

  ColorSwitcher({required super.position, this.radius = 24})
      : super(anchor: Anchor.center, size: Vector2.all(radius * 2));

  @override
  Future<void> onLoad() async {
    // load the image asset as a sprite
    //sprite = await Sprite.load('star.png');
    add(
      RotateEffect.to(
        math.pi * 2,
        EffectController(speed: 1, infinite: true),
      ),
    );

    add(
      CircleHitbox(
          radius: radius,
          anchor: anchor,
          position: size / 2,
          collisionType: CollisionType.passive),
    );
  }

  @override
  void render(Canvas canvas) {
    //sprite.render(canvas, size: Vector2.all(radius * 2), anchor: Anchor.center);
    final length = gameRef.colors.length;
    final sweepAngle = math.pi * 2 / length;
    for (int i = 0; i < length; i++) {
      canvas.drawArc(size.toRect(), i * sweepAngle, sweepAngle, true,
          Paint()..color = gameRef.colors[i]);
    }
  }
}
