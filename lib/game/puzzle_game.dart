import 'package:aandd_puzzle/game/board_coordinate.dart';
import 'package:aandd_puzzle/game/game_config.dart';
import 'package:aandd_puzzle/game/game_state.dart';
import 'package:aandd_puzzle/game/game_tile.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class PuzzleGame extends FlameGame
    with HasHoverables, HasTappables, FPSCounter {
  final GameConfig gameConfig;
  final tiles = <GameTileLite>[];
  late BoardCoordinate _emptySlot;
  late TextComponent textComponent;
  final gameState = GameState();

  PuzzleGame({
    required this.gameConfig,
  });

  static final fpsTextPaint = TextPaint(
    style: const TextStyle(color: Color(0xFFFFFFFF)),
  );

  final _regularTextStyle = TextStyle(
    fontSize: 18,
    color: BasicPalette.white.color,
  );

  @override
  bool debugMode = true;

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (debugMode) {
      fpsTextPaint.render(canvas, 'FPS: ${fps(120)}', Vector2(0, 450));
    }
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(ScreenCollidable());
    await _initiate(
      const GameConfig(
        width: 4,
        height: 4,
      ),
    );
    // TODO: fix
    // _shuffle();
    final win = _checkWin();
    textComponent.text = 'win: $win';
  }

  Future<void> _initiate(GameConfig config) async {
    final spriteImage = await images.load('dash_squared_small.png');
    final spritesheet = SpriteSheet.fromColumnsAndRows(
      image: spriteImage,
      columns: config.width,
      rows: config.height,
    );

    for (var i = 0; i < spritesheet.columns; i++) {
      for (var y = 0; y < spritesheet.rows; y++) {
        final sprite = spritesheet.getSprite(y, i);
        if (i != spritesheet.columns - 1 || y != spritesheet.rows - 1) {
          final tile = GameTileLite(
            onTap: _onTap,
            sprite: sprite,
            coordinate: BoardCoordinate(x: i, y: y),
            position: Vector2(
              sprite.srcPosition.x + sprite.srcSize.x / 2,
              sprite.srcPosition.y + sprite.srcSize.y / 2,
            ),
            size: sprite.srcSize,
            anchor: Anchor.center,
          );
          add(tile);
          tiles.add(tile);
        } else {
          _emptySlot = BoardCoordinate(x: i, y: y);
        }
      }
    }

    textComponent = TextComponent(
      text: '',
      textRenderer: TextPaint(style: _regularTextStyle),
      anchor: Anchor.topLeft,
      position: Vector2(
        0.0,
        spriteImage.height + 10,
      ),
    );
    add(textComponent);
  }

  bool _closeToEmptySlot(BoardCoordinate coordinate) {
    for (final neighbor in coordinate.getNeighbors()) {
      if (neighbor == _emptySlot) {
        return true;
      }
    }
    return false;
  }

  void _moveTile({
    required BoardCoordinate from,
    required BoardCoordinate to,
  }) {
    final tileToMove =
        tiles.firstWhere((tile) => tile.currentCoordinate == from);
    tileToMove.move(to);
    _emptySlot = from;
    // check if it is winner position
    final win = _checkWin();
    textComponent.text = 'win: $win';
  }

  void undo() {
    final lastMove = gameState.revert();
    if (lastMove != null) {
      _moveTile(
        from: lastMove.after,
        to: lastMove.before,
      );
    }
  }

  void _shuffle() {
    final shuffledCoordinates =
        (tiles.map((e) => e.currentCoordinate).cast<BoardCoordinate>().toList()
          ..shuffle());

    final copyIfTiles = [...tiles];
    for (final coordinate in shuffledCoordinates) {
      final tile = copyIfTiles.removeLast();
      tile.move(coordinate);
    }
  }

  void _onTap(BoardCoordinate coordinate) {
    if (_closeToEmptySlot(coordinate)) {
      // keep game state before moving tile
      gameState.keep(
        GameMove(
          before: coordinate,
          after: _emptySlot,
        ),
      );
      _moveTile(
        from: coordinate,
        to: _emptySlot,
      );
    }
  }

  bool _checkWin() {
    for (final tile in tiles) {
      if (!tile.isInTheRigthPlace) {
        return false;
      }
    }
    return true;
  }
}
