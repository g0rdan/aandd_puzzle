import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/palette.dart';

class GameTile extends SpriteAnimationComponent
    with HasHitboxes, Collidable, HasGameRef {
  final Vector2 velocity;
  final List<Collidable> activeCollisions = [];
  final int index;

  GameTile(
    this.index,
    this.velocity,
    Vector2 position, {
    double angle = -pi / 4,
  }) : super(
          position: position,
          size: Vector2(150, 200),
          angle: angle,
          anchor: Anchor.topLeft,
        );

  late HitboxPolygon hitbox;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // final sprite = await Sprite.load('dash.png');
    // final size = Vector2.all(128.0);
    // final player = SpriteComponent(size: size, sprite: sprite);

    animation = await gameRef.loadSpriteAnimation(
      'dash.png',
      SpriteAnimationData.sequenced(
        amount: index + 1,
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
