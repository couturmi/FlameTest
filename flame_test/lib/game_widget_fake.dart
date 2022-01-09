import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/src/extensions/size.dart';
import 'package:flame/src/game/game_render_box.dart';
import 'package:flame/src/game/game_widget/gestures.dart';
import 'package:flame_test/game_fake.dart';
import 'package:flame_test/game_render_box_fake.dart';
import 'package:flame_test/main.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

typedef GameLoadingWidgetBuilder = Widget Function(
  BuildContext,
);

typedef GameErrorWidgetBuilder = Widget Function(
  BuildContext,
  Object error,
);

typedef OverlayWidgetBuilder<T extends GameFake> = Widget Function(
  BuildContext context,
  T game,
);

/// A [StatefulWidget] that is in charge of attaching a [Game] instance into the
/// Flutter tree.
class GameWidgetFake<T extends GameFake> extends StatefulWidget {
  /// The game instance in which this widget will render
  final T game;

  /// The text direction to be used in text elements in a game.
  final TextDirection? textDirection;

  /// Builder to provide a widget tree to be built while the Game's [Future]
  /// provided via `Game.onLoad` and `Game.onMount` is not resolved.
  /// By default this is an empty Container().
  final GameLoadingWidgetBuilder? loadingBuilder;

  /// If set, errors during the onLoad method will not be thrown
  /// but instead this widget will be shown. If not provided, errors are
  /// propagated up.
  final GameErrorWidgetBuilder? errorBuilder;

  /// Builder to provide a widget tree to be built between the game elements and
  /// the background color provided via [Game.backgroundColor].
  final WidgetBuilder? backgroundBuilder;

  /// A map to show widgets overlay.
  ///
  /// See also:
  /// - [new GameWidget]
  /// - [Game.overlays]
  final Map<String, OverlayWidgetBuilder<T>>? overlayBuilderMap;

  /// A List of the initially active overlays, this is used only on the first
  /// build of the widget.
  /// To control the overlays that are active use [Game.overlays].
  ///
  /// See also:
  /// - [new GameWidget]
  /// - [Game.overlays]
  final List<String>? initialActiveOverlays;

  /// The [FocusNode] to control the games focus to receive event inputs.
  /// If omitted, defaults to an internally controlled focus node.
  final FocusNode? focusNode;

  /// Whether the [focusNode] requests focus once the game is mounted.
  /// Defaults to true.
  final bool autofocus;

  /// Initial mouse cursor for this [GameWidget]
  /// mouse cursor can be changed in runtime using [Game.mouseCursor]
  final MouseCursor? mouseCursor;

  const GameWidgetFake({
    Key? key,
    required this.game,
    this.textDirection,
    this.loadingBuilder,
    this.errorBuilder,
    this.backgroundBuilder,
    this.overlayBuilderMap,
    this.initialActiveOverlays,
    this.focusNode,
    this.autofocus = true,
    this.mouseCursor,
  }) : super(key: key);

  /// Renders a [game] in a flutter widget tree alongside widgets overlays.
  ///
  /// To use overlays, the game subclass has to be mixed with HasWidgetsOverlay.
  @override
  _GameWidgetFakeState<T> createState() => _GameWidgetFakeState<T>();
}

class _GameWidgetFakeState<T extends GameFake>
    extends State<GameWidgetFake<T>> {
  Future<void> get loaderFuture => _loaderFuture ??= (() {
        final onLoad = widget.game.onLoadCache;
        final onMount = widget.game.onMount;
        return (onLoad ?? Future<void>.value()).then((_) => onMount());
      })();

  Future<void>? _loaderFuture;

  @override
  Widget build(BuildContext context) {
    Widget internalGameWidget = _GameRenderObjectWidget(widget.game);

    // We can use Directionality.maybeOf when that method lands on stable
    final textDir = widget.textDirection ?? TextDirection.ltr;

    return Directionality(
      textDirection: textDir,
      child: LayoutBuilder(
        builder: (_, BoxConstraints constraints) {
          (widget.game as MyGame)
              .updateText("LayoutBuilder occurred\n\t${constraints.biggest}\n");
          widget.game.onGameResize(constraints.biggest.toVector2());
          return FutureBuilder(
            future: loaderFuture,
            builder: (_, snapshot) {
              if (snapshot.hasError) {
                final errorBuilder = widget.errorBuilder;
                if (errorBuilder == null) {
                  throw snapshot.error!;
                } else {
                  return errorBuilder(context, snapshot.error!);
                }
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return internalGameWidget;
                // return Center(child: Text("${constraints.biggest}"));
              }
              return widget.loadingBuilder?.call(context) ?? Container();
            },
          );
        },
      ),
    );
    // ),
    // );
  }
}

class _GameRenderObjectWidget extends LeafRenderObjectWidget {
  final GameFake game;

  const _GameRenderObjectWidget(this.game);

  @override
  RenderBox createRenderObject(BuildContext context) {
    return GameRenderBoxFake(context, game);
  }

  @override
  void updateRenderObject(
      BuildContext context, GameRenderBoxFake renderObject) {
    renderObject.game = game;
  }
}
