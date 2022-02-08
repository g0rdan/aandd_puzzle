import 'package:aandd_puzzle/game/board_coordinate.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/widgets.dart';

class GameTileLite extends SpriteComponent with Tappable, Hoverable {
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
  void render(Canvas canvas) {
    super.render(canvas);
    add(
      ScaleEffect.to(
        Vector2.all(isHovered ? 0.9 : 1.0),
        EffectController(
          duration: 0.1,
          curve: Curves.linear,
        ),
      ),
    );
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
          size.x * point.x + size.x / 2,
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
}
