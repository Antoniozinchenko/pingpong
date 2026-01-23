import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'game.dart';

void main() {
  final game = PingPongGame();
  runApp(GameWidget(game: game));
}
