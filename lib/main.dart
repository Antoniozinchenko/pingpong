import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game/ping_pong_game.dart';

void main() {
  runApp(const GameApp());
}

class GameApp extends StatelessWidget {
  const GameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ping Pong',
      home: Center(
        child: SizedBox(
          width: 800,
          height: 1200,
          child: GameWidget(game: PingPongGame()),
        ),
      ),
    );
  }
}
