import 'dart:math';

import 'package:aandd_puzzle/game/game_config.dart';
import 'package:aandd_puzzle/game/game_tile.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';

class PuzzleGame extends FlameGame with HasCollidables {
  final GameConfig gameConfig;

  PuzzleGame({
    required this.gameConfig,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(ScreenCollidable());

    const columns = 2;
    const rows = 2;
    const frames = columns * rows;
    final spriteImage = await images.load('dash_squared_small.png');
    final spritesheet = SpriteSheet.fromColumnsAndRows(
      image: spriteImage,
      columns: columns,
      rows: rows,
    );

    // final sprites = List<Sprite>.generate(frames, spritesheet.getSpriteById);

    for (var i = 0; i < spritesheet.columns; i++) {
      for (var y = 0; y < spritesheet.rows; y++) {
        final sprite = spritesheet.getSprite(y, i);
        add(
          SpriteComponent(
            sprite: sprite,
            position: Vector2(
              sprite.srcPosition.x,
              sprite.srcPosition.y,
            ), //position,
            size: sprite.srcSize,
            anchor: Anchor.topLeft,
          ),
        );
      }
    }

    final spriteAmount = gameConfig.width * gameConfig.height;
    // for (var i = 0; i < spriteAmount; i++) {
    //   final sprite = GameTile(
    //     i,
    //     Vector2(
    //       (Random().nextBool() ? -1 : 1) * Random().nextInt(100).toDouble(),
    //       (Random().nextBool() ? -1 : 1) * Random().nextInt(100).toDouble(),
    //     ),
    //     Vector2(
    //       Random().nextInt(size.x.toInt() - 100).toDouble(),
    //       Random().nextInt(size.y.toInt() - 100).toDouble(),
    //     ),
    //     angle: pi / Random().nextInt(4),
    //   );

    //   if (Random().nextBool()) {
    //     sprite.flipVertically();
    //   }
    //   add(sprite);
    // }
  }
}
