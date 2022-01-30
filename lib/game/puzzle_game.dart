import 'package:aandd_puzzle/game/collidable_animation_example.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class PuzzleGame extends StatefulWidget {
  const PuzzleGame({Key? key}) : super(key: key);

  @override
  State<PuzzleGame> createState() => _PuzzleGameState();
}

class _PuzzleGameState extends State<PuzzleGame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: GameWidget(
          game: CollidableAnimationExample(),
        ),
      ),
    );
  }
}
