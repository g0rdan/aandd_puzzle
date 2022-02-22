import 'dart:math';

import 'package:aandd_puzzle/game/board_coordinate.dart';
import 'package:aandd_puzzle/game/game_config.dart';
import 'package:aandd_puzzle/game/game_state.dart';
import 'package:aandd_puzzle/game/game_tile.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class PuzzleGame extends FlameGame
    with HasHoverables, HasCollidables, HasTappables, FPSCounter {
  final GameConfig gameConfig;
  final tiles = <GameTileLite>[];
  late BoardCoordinate _emptySlot;
  late TextComponent textComponent;

  final _gameState = GetIt.instance.get<GameState>();

  PuzzleGame({
    required this.gameConfig,
  });

  static final fpsTextPaint = TextPaint(
    style: const TextStyle(color: Color(0xFF000000)),
  );

  final _regularTextStyle = TextStyle(
    fontSize: 18,
    color: BasicPalette.white.color,
  );

  @override
  bool debugMode = const String.fromEnvironment('debug_flame') == 'true';

  @override
  Color backgroundColor() => const Color(0xFFFFFFFF);

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (debugMode) {
      fpsTextPaint.render(
        canvas,
        'FPS: ${fps(120)}',
        Vector2(10, size.y - 24),
      );
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(ScreenCollidable());
    await _initiate(gameConfig);
    _shuffle(30);
  }

  Future<void> _initiate(GameConfig config) async {
    final spriteImage = await images.load(gameConfig.gameImage);
    final scaleFactor =
        spriteImage.width > size.x ? size.x / spriteImage.width : 1.0;
    final startX = (size.x - spriteImage.size.x * scaleFactor) / 2;

    final spriteSheet = SpriteSheet.fromColumnsAndRows(
      image: spriteImage,
      columns: config.width,
      rows: config.height,
    );

    for (var i = 0; i < spriteSheet.columns; i++) {
      for (var y = 0; y < spriteSheet.rows; y++) {
        final sprite = spriteSheet.getSprite(y, i);
        if (i != spriteSheet.columns - 1 || y != spriteSheet.rows - 1) {
          final newSize = Vector2(
            sprite.srcSize.x * scaleFactor,
            sprite.srcSize.y * scaleFactor,
          );

          final xC = sprite.srcPosition.x + newSize.x / 2 + startX;
          final yC = sprite.srcPosition.y + newSize.y / 2;

          final tile = GameTileLite(
            onTap: _onTap,
            sprite: sprite,
            coordinate: BoardCoordinate(x: i, y: y),
            position: Vector2(xC, yC),
            size: newSize,
            anchor: Anchor.center,
            startX: startX,
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
    for (final neighbor in coordinate.getNeighbors(
      boardWidth: gameConfig.width,
      boardHeigth: gameConfig.height,
    )) {
      if (neighbor == _emptySlot) {
        return true;
      }
    }
    return false;
  }

  void _moveTile({
    required BoardCoordinate from,
    required BoardCoordinate to,
    bool animation = true,
  }) {
    final tileToMove =
        tiles.firstWhere((tile) => tile.currentCoordinate == from);
    if (animation) {
      tileToMove.move(to);
    } else {
      tileToMove.moveNoAnimation(to);
    }

    _emptySlot = from;
    // check if it is winner position
    if (animation) _checkWin();
  }

  void undo() {
    final lastMove = _gameState.revert();
    if (lastMove != null) {
      _moveTile(
        from: lastMove.after,
        to: lastMove.before,
      );
    }
  }

  void _shuffle(int steps) {
    BoardCoordinate? choosen;
    for (var i = 0; i < steps; i++) {
      final neiborsOfEmpty = _emptySlot
          .getNeighbors(
            boardWidth: gameConfig.width,
            boardHeigth: gameConfig.height,
          )
          .where((neibor) => neibor != choosen)
          .toList();
      choosen = neiborsOfEmpty[Random().nextInt(neiborsOfEmpty.length)];
      _moveTile(from: choosen, to: _emptySlot, animation: false);
    }
  }

  void _onTap(BoardCoordinate coordinate) {
    if (_closeToEmptySlot(coordinate)) {
      // keep game state before moving tile
      _gameState.keep(
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

  void _checkWin() {
    bool win = true;
    for (final tile in tiles) {
      if (!tile.isInTheRigthPlace) {
        win = false;
        break;
      }
    }

    _gameState.win = win;
    textComponent.text = 'win: $win';

    tiles.forEach((tile) {
      tile.scaleTo(win ? 1.0 : 0.9);
    });
  }
}
