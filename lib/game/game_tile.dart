import 'package:aandd_puzzle/game/board_coordinate.dart';
import 'package:flame/components.dart';

class GameTileLite extends SpriteComponent with Tappable {
  final Sprite _sprite;
  BoardCoordinate? coordinate;
  final Function(BoardCoordinate) onTap;

  GameTileLite({
    required Sprite sprite,
    required int positionX,
    required int positionY,
    required this.onTap,
    Vector2? position,
    Vector2? size,
    Anchor? anchor,
  })  : _sprite = sprite,
        coordinate = BoardCoordinate(
          x: positionX,
          y: positionY,
        ),
        super(
          sprite: sprite,
          position: position,
          size: size,
          anchor: anchor,
        );

  @override
  bool onTapDown(info) {
    onTap(coordinate!);
    return true;
  }

  void move(BoardCoordinate point) {
    position = Vector2(
      size.x * point.x,
      size.y * point.y,
    );
    coordinate = point;
  }
}
