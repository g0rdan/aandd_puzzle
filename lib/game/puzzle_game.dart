import 'dart:math';
import 'dart:ui';

import 'package:aandd_puzzle/game/game_config.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:flame/palette.dart';

class PuzzleGame extends FlameGame with HasCollidables {
  final GameConfig gameConfig;

  PuzzleGame({
    required this.gameConfig,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(ScreenCollidable());

    final spriteAmount = gameConfig.width * gameConfig.height;
    for (var i = 0; i < spriteAmount; i++) {
      final sprite = TileComponent(
        Vector2(
          (Random().nextBool() ? -1 : 1) * Random().nextInt(100).toDouble(),
          (Random().nextBool() ? -1 : 1) * Random().nextInt(100).toDouble(),
        ),
        Vector2(
          Random().nextInt(size.x.toInt() - 100).toDouble(),
          Random().nextInt(size.y.toInt() - 100).toDouble(),
        ),
        angle: pi / Random().nextInt(4),
      );

      if (Random().nextBool()) {
        sprite.flipVertically();
      }
      add(sprite);
    }
  }
}

class TileComponent extends SpriteAnimationComponent
    with HasHitboxes, Collidable, HasGameRef {
  final Vector2 velocity;
  final List<Collidable> activeCollisions = [];

  TileComponent(this.velocity, Vector2 position, {double angle = -pi / 4})
      : super(
          position: position,
          size: Vector2(150, 100),
          angle: angle,
          anchor: Anchor.center,
        );

  late HitboxPolygon hitbox;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    animation = await gameRef.loadSpriteAnimation(
      'bomb_ptero.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.2,
        textureSize: Vector2.all(48),
      ),
    );
    hitbox = HitboxPolygon([
      Vector2(0.0, -1.0),
      Vector2(-1.0, -0.1),
      Vector2(-0.2, 0.4),
      Vector2(0.2, 0.4),
      Vector2(1.0, -0.1),
    ]);
    addHitbox(hitbox);
  }

  @override
  void update(double dt) {
    position += velocity * dt;
  }

  final Paint hitboxPaint = BasicPalette.green.paint()
    ..style = PaintingStyle.stroke;
  final Paint dotPaint = BasicPalette.red.paint()..style = PaintingStyle.stroke;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // This is just to clearly see the vertices in the hitboxes
    hitbox.render(canvas, hitboxPaint);
    hitbox
        .localVertices()
        .forEach((p) => canvas.drawCircle(p.toOffset(), 4, dotPaint));
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    if (!activeCollisions.contains(other)) {
      velocity.negate();
      flipVertically();
      activeCollisions.add(other);
    }
  }

  @override
  void onCollisionEnd(Collidable other) {
    activeCollisions.remove(other);
  }
}
