import 'dart:core';
import 'package:firstgame/color_switcher.dart';
import 'package:firstgame/ground.dart';
import 'package:firstgame/player.dart';
import 'package:firstgame/rotator.dart';
import 'package:firstgame/star.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/particles.dart';
import 'package:flame/rendering.dart';
import 'package:flame/src/camera/camera_component.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'dart:math' as math;

class MyGame extends FlameGame
    with TapCallbacks, HasCollisionDetection, HasDecorator, HasTimeScale {
  late Player _player;
  late Sprite sprite;
  double initial_y = -100;
  final List<Color> colors;
  late double blurness = 0.0;

  final ValueNotifier<int> score = ValueNotifier(0);

  final List<PositionComponent> _rotators = [];

  @override
  Color backgroundColor() => Color(0xff222222);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await Flame.images.loadAll([
      'star.png',
      'finger.png',
    ]);



    FlameAudio.bgm.initialize();
    Flame.device.setPortrait();
  }

  MyGame(
      {this.colors = const [
        Colors.redAccent,
        Colors.greenAccent,
        Colors.blueAccent,
        Colors.yellowAccent,
      ]})
      : super(
          camera: CameraComponent.withFixedResolution(width: 600, height: 1200),
        );

  @override
  void onMount() {
    initGame();
    super.onMount();
  }

  @override
  void update(double dt) {
    super.update(dt);
    final cameraY = camera.viewfinder.position.y;
    final playerY = _player.position.y;

    if (playerY < cameraY) {
      camera.viewfinder.position = Vector2(0, playerY);
    }

    //destroy the last rotator if it is out of the screen
    if (_rotators.isNotEmpty) {
      final lastRotator = _rotators.first;
      if (lastRotator.position.y > playerY + 700) {
        lastRotator.removeFromParent();
        _rotators.remove(lastRotator);
        print(_rotators.length);
        initial_y -= 500;
        generateRandomComponent(Vector2(0, initial_y));
      }
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    _player.jump();
    super.onTapDown(event);
  }

  void initGame() {
    FlameAudio.bgm.play('cosmic.mp3');
    _rotators.clear();
    world.add(Ground(position: Vector2(0, 400)));
    world.add(_player = Player(position: Vector2(0, 400)));

    //make the game infinite by generating random rotators
    generateRandomComponent(Vector2(0, initial_y));
    initial_y -= 500;
    generateRandomComponent(Vector2(0, initial_y));
    initial_y -= 500;
    generateRandomComponent(Vector2(0, initial_y));
    initial_y -= 500;
    generateRandomComponent(Vector2(0, initial_y));
  }

  void addRotator(PositionComponent rotator) {
    _rotators.add(rotator);
    world.add(rotator);
  }

  void generateRandomComponent(Vector2 position) {
    final rnd = math.Random();
    double size = rnd.nextDouble() * 70 + 180;
    double thickness = (rnd.nextInt(10) + 10).toDouble();
    double speed = math.Random().nextDouble() * 4 + 2;
    generateComponent(Vector2.all(size), position, thickness, speed);
  }

  void generateComponent(
      Vector2 size, Vector2 position, double thickness, double speed) {
    addRotator(
      Rotator(
          size: size,
          position: position,
          thickness: thickness,
          rotationSpeed: speed),
    );
    world.add(Star(position: position, radius: 40));
    generateColorSwitcher(
        position + Vector2(0, math.Random().nextDouble() * 120 + 180));
  }

  void generateColorSwitcher(Vector2 position) {
    world.add(ColorSwitcher(position: position));
  }

  void gameOver() {
    for (var element in world.children) {
      FlameAudio.bgm.stop();
      element.removeFromParent();
    }
    Future.delayed(Duration(seconds: 2), () {
      initial_y = -100;
      camera.moveTo(Vector2(0, 0));
      score.value = 0;
      initGame();
    });
  }

  bool get isGamePaused => timeScale == 0;

  void pauseGame() {
    decorator = PaintDecorator.blur(3.0);
    timeScale = 0;
    FlameAudio.bgm.pause();
    //pauseEngine();
  }

  void resumeGame() {
    decorator = PaintDecorator.blur(0.0);
    timeScale = 1;
    FlameAudio.bgm.resume();
    //resumeEngine();
  }

  void increaseScore() {
    score.value++;
  }
}
