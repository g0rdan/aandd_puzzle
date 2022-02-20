import 'dart:io';

import 'package:aandd_puzzle/game/board_coordinate.dart';
import 'package:aandd_puzzle/game/game_state.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class GameTileLite extends SpriteComponent with Tappable, Hoverable {
  final Sprite _sprite;
  final GameState gameState;
  final Function(BoardCoordinate) onTap;
  final BoardCoordinate _rigthCoordinate;
  final double startX;
  BoardCoordinate? currentCoordinate;
  bool? _hovered;

  bool get isInTheRigthPlace => _rigthCoordinate == currentCoordinate;

  GameTileLite({
    required Sprite sprite,
    required BoardCoordinate coordinate,
    required this.gameState,
    required this.onTap,
    required this.startX,
    Vector2? position,
    Vector2? size,
    Anchor? anchor,
  })  : _sprite = sprite,
        _rigthCoordinate = coordinate,
        currentCoordinate = coordinate,
        super(
          sprite: sprite,
          position: position,
          size: size,
          anchor: anchor,
        );

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // we want to "assemble" picture once player solves the puzzle
    if (gameState.win) {
      return;
    }

    // remove "bouncing" scale
    if (_hovered != isHovered) {
      _hovered = isHovered;
      scaleTo(isHovered ? 1.0 : 0.9);
    }
  }

  @override
  bool onTapDown(info) {
    onTap(currentCoordinate!);
    return true;
  }

  void move(BoardCoordinate point) {
    add(
      MoveEffect.to(
        Vector2(
          size.x * point.x + size.x / 2 + startX,
          size.y * point.y + size.y / 2,
        ),
        EffectController(
          duration: 0.3,
          curve: Curves.easeInOut,
        ),
      ),
    );
    currentCoordinate = point;
  }

  void moveNoAnimation(BoardCoordinate point) {
    position = Vector2(
      size.x * point.x + size.x / 2 + startX,
      size.y * point.y + size.y / 2,
    );
    currentCoordinate = point;
  }

  void scaleTo(double ratio) {
    add(
      ScaleEffect.to(
        Vector2.all(ratio),
        EffectController(
          duration: 0.1,
          curve: Curves.linear,
        ),
      ),
    );
  }
}
