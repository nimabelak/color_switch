import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

class Star extends PositionComponent with CollisionCallbacks {
  late Sprite star_sprite;
  final double radius;

  Star({required super.position, this.radius = 14.0});

  @override
  FutureOr<void> onLoad() async {
    star_sprite = await Sprite.load("star.png");

    add(
      CircleHitbox(
          radius: radius / 2 - 1,
          anchor: Anchor.center,
          collisionType: CollisionType.passive),
    );
  }

  @override
  void render(Canvas canvas) {
    star_sprite.render(canvas,
        size: Vector2.all(radius), anchor: Anchor.center);
    position = position;
  }

  void showCollectEffect() {
    final rnd = math.Random();
    Vector2 randomVector2() =>
        (Vector2.random(rnd) - Vector2.random(rnd)) * 500;

    parent!.add(
      ParticleSystemComponent(
        position: position,
        particle: Particle.generate(
          count: 12,
          generator: (i) {
            return AcceleratedParticle(
              speed: randomVector2(),
              acceleration: randomVector2(),
              child: RotatingParticle(
                to: rnd.nextDouble() * 2 * math.pi,
                child: ComputedParticle(
                  lifespan: 1.0,
                  renderer: (canvas, particle) {
                    star_sprite.render(
                      canvas,
                      size:
                          Vector2.all(radius / 2) * (1 - particle.progress / 2),
                      anchor: Anchor.center,
                      overridePaint: Paint()
                        ..color =
                            Colors.white.withOpacity(1 - particle.progress),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
    removeFromParent();
  }
}
