import 'dart:async';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Ground extends PositionComponent {
  static const String groundKey = 'ground';
  Ground({required super.position})
      : super(
            size: Vector2(200, 2),
            anchor: Anchor.center,
            key: ComponentKey.named(groundKey));

  late Sprite fingerSprite;
  @override
  Future<void> onLoad() async {
    fingerSprite = await Sprite.load('finger.png');
    await super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    fingerSprite.render(canvas,
        size: Vector2.all(128), position: Vector2(47, 0));

    super.render(canvas);
  }
}
