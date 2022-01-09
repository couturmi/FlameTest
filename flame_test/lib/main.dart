import 'package:flame/components.dart';
import 'package:flame_test/flame_game_fake.dart';
import 'package:flame_test/game_widget_fake.dart';
import 'package:flutter/material.dart';

class MyGame extends FlameGameFake {
  String text = "";
  TextComponent textComponent =
      TextComponent(text: "", position: Vector2(50, 50));
  @override
  Future<void> onLoad() async {
    updateText("onLoad occurred\n");
    await super.onLoad();
    add(textComponent);
  }

  void updateText(String newText) {
    text += newText;
    textComponent.text = text;
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    updateText("onGameResize occurred\n\tCanvas Size: $canvasSize\n");
    super.onGameResize(canvasSize);
  }
}

main() {
  final myGame = MyGame();
  runApp(
    GameWidgetFake<MyGame>(
      game: myGame,
      autofocus: false,
    ),
  );
}

// void main() {
//   runApp(const MyAppStateful());
// }
//
// class MyAppStateful extends StatefulWidget {
//   const MyAppStateful({Key? key}) : super(key: key);
//
//   @override
//   _MyAppStatefulState createState() => _MyAppStatefulState();
// }
//
// class _MyAppStatefulState extends State<MyAppStateful> {
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
