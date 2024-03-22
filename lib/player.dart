import 'dart:async';
import 'dart:math';

import 'package:firstgame/color_switcher.dart';
import 'package:firstgame/game.dart';
import 'package:firstgame/ground.dart';
import 'package:firstgame/rotator.dart';
import 'package:firstgame/star.dart';
import 'package:flame/collisions.dart';
import 'package:flame/extensions.dart';
import 'package:flame/particles.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'dart:math' as math;

class Player extends PositionComponent
    with HasGameRef<MyGame>, CollisionCallbacks, HasTimeScale {
  Player({
    required super.position,
    this.playerRadius = 14,
    this.playerColor = Colors.white,
  }) : super(priority: 10);

  final _velocity = Vector2.zero();
  final _gravity = 980.0;
  final _jumpSpeed = 350.0;

  final double playerRadius;
  late Color playerColor;

  @override
  void onMount() {
    size = Vector2.all(playerRadius * 2); //ghotr
    anchor = Anchor.center;
    super.onMount();
  }

  @override
  void update(double dt) {
    super.update(dt);
    timeScale = 1.4;
    position += _velocity * dt;

    Ground ground = gameRef.findByKeyName(Ground.groundKey)!;

    if (positionOfAnchor(Anchor.bottomCenter).y > ground.position.y) {
      position.y = ground.position.y - size.y / 2;
      _velocity.y = 0;
    }

    _velocity.y += _gravity * dt;
  }

  @override
  void onLoad() {
    super.onLoad();
    add(
      CircleHitbox(
          radius: playerRadius,
          anchor: anchor,
          collisionType: CollisionType.active),
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(
      (size / 2).toOffset(),
      playerRadius,
      Paint()..color = playerColor,
    );
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    if (other is ColorSwitcher) {
      other.removeFromParent();
      changeRandomColor();
    } else if (other is CircleArc) {
      if (playerColor != other.color) {
        FlameAudio.bgm.pause();
        FlameAudio.play('fart.wav');
        
        gameRef.gameOver();

      }
    } else if (other is Star) {
      FlameAudio.play('huh.wav');
      other.showCollectEffect();
      gameRef.increaseScore();
    }
    super.onCollision(points, other);
  }

  void jump() {
    _velocity.y = -_jumpSpeed;
  }

  void changeRandomColor() {
    playerColor = gameRef.colors.random();
  }
}
