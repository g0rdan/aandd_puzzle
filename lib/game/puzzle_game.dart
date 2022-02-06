import 'package:aandd_puzzle/game/board_coordinate.dart';
import 'package:aandd_puzzle/game/game_config.dart';
import 'package:aandd_puzzle/game/game_tile.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class PuzzleGame extends FlameGame
    with HasCollidables, HasTappables, FPSCounter {
  final GameConfig gameConfig;
  final tiles = <GameTileLite>[];
  late BoardCoordinate _emptySlot;

  PuzzleGame({
    required this.gameConfig,
  });

  static final fpsTextPaint = TextPaint(
    style: const TextStyle(color: Color(0xFFFFFFFF)),
  );

  @override
  bool debugMode = true;

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (debugMode) {
      fpsTextPaint.render(canvas, fps(120).toString(), Vector2(0, 50));
    }
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(ScreenCollidable());

    const columns = 2;
    const rows = 2;
    final spriteImage = await images.load('dash_squared_small.png');
    final spritesheet = SpriteSheet.fromColumnsAndRows(
      image: spriteImage,
      columns: columns,
      rows: rows,
    );

    for (var i = 0; i < spritesheet.columns; i++) {
      for (var y = 0; y < spritesheet.rows; y++) {
        final sprite = spritesheet.getSprite(y, i);
        if (i != spritesheet.columns - 1 || y != spritesheet.rows - 1) {
          final tile = GameTileLite(
            onTap: (tap) {
              final result = _closeToEmptySlot(tap);
              if (result) {
                _moveTile(tap, _emptySlot);
              }
            },
            sprite: sprite,
            positionX: i,
            positionY: y,
            position: Vector2(
              sprite.srcPosition.x,
              sprite.srcPosition.y,
            ),
            size: sprite.srcSize,
            anchor: Anchor.topLeft,
          );
          add(tile);
          tiles.add(tile);
        } else {
          _emptySlot = BoardCoordinate(x: i, y: y);
        }
      }
    }
  }

  bool _closeToEmptySlot(BoardCoordinate coordinate) {
    for (final neighbor in coordinate.getNeighbors()) {
      if (neighbor == _emptySlot) {
        return true;
      }
    }
    return false;
  }

  void _moveTile(BoardCoordinate coordinate, BoardCoordinate emptySlot) {
    final copyCoordinates = coordinate.copy();
    final rigthTile = tiles.firstWhere((tile) => tile.coordinate == coordinate);
    rigthTile.move(emptySlot);
    _emptySlot = copyCoordinates;
  }
}
