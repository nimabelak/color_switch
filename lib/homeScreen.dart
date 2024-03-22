import 'package:firstgame/game.dart';
import 'package:flame/game.dart';
import 'package:flame/rendering.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late MyGame _myGame;
  @override
  void initState() {
    _myGame = MyGame();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GameWidget(game: _myGame),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: _myGame.isGamePaused
                      ? const SizedBox()
                      : const Icon(
                          Icons.pause,
                          size: 48,
                        ),
                  onPressed: () {
                    setState(() {
                      _myGame.pauseGame();
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                  alignment: Alignment.topRight,
                  child: ValueListenableBuilder(
                      valueListenable: _myGame.score,
                      builder: (context, int value, child) {
                        return Text(
                          value.toString(),
                          style: TextStyle(fontSize: 48),
                        );
                      })),
            ),
            if (_myGame.isGamePaused)
              Container(
                color: Colors.black38,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Game Paused",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _myGame.resumeGame();
                          });
                        },
                        icon: const Icon(
                          Icons.play_arrow,
                          size: 64,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
