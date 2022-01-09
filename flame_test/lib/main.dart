import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_test/game_widget_fake.dart';
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
    GameWidgetFake(
      game: myGame,
      autofocus: false,
    ),
  );
}

// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.ltr,
//       child: LayoutBuilder(
//         builder: (_, BoxConstraints constraints) {
//           return Center(child: Text("Constraints: ${constraints.biggest}"));
//         },
//       ),
//     );
//   }
// }
