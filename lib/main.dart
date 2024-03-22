import 'package:firstgame/game.dart';
import 'package:firstgame/homeScreen.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        title: "Color Switch",
        home: Home(),
      ),
    );
  }
}
