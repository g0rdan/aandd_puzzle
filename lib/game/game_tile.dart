import 'package:aandd_puzzle/game/board_coordinate.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/widgets.dart';

class GameTileLite extends SpriteComponent with Tappable {
  final Sprite _sprite;
  final Function(BoardCoordinate) onTap;
  final BoardCoordinate _rigthCoordinate;
  BoardCoordinate? currentCoordinate;

  bool get isInTheRigthPlace => _rigthCoordinate == currentCoordinate;

  GameTileLite({
    required Sprite sprite,
    required BoardCoordinate coordinate,
    required this.onTap,
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
  bool onTapDown(info) {
    onTap(currentCoordinate!);
    return true;
  }

  void move(BoardCoordinate point) {
    add(
      MoveEffect.to(
        Vector2(
          size.x * point.x,
          size.y * point.y,
        ),
        EffectController(
          duration: 0.3,
          curve: Curves.easeInOut,
        ),
      ),
    );
    currentCoordinate = point;
  }
}
