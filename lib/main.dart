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
      theme: ThemeData.dark(),
      home: GameWidget(game: PingPongGame()),
    );
  }
}
