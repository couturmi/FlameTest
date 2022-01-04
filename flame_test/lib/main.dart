import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class MyGame extends FlameGame {
  String text = "";
  @override
  Future<void> onLoad() async {
    text += "onLoad occurred\n";
    await super.onLoad();
    add(TextComponent(text: text, position: Vector2(50, 50)));
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    text += "onGameResize occurred\n\tCanvas Size: $canvasSize\n";
    super.onGameResize(canvasSize);
  }
}

main() {
  final myGame = MyGame();
  runApp(
    GameWidget(
      game: myGame,
    ),
  );
}
