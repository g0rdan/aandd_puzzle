import 'package:aandd_puzzle/game/puzzle_game.dart';
import 'package:aandd_puzzle/game/game_config.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class MainGame extends StatefulWidget {
  const MainGame({Key? key}) : super(key: key);

  @override
  State<MainGame> createState() => _MainGameState();
}

class _MainGameState extends State<MainGame> {
  late PuzzleGame puzzleGame;

  @override
  void initState() {
    super.initState();
    puzzleGame = PuzzleGame(
      gameConfig: const GameConfig(
        width: 4,
        height: 4,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: GameWidget(
          game: puzzleGame,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.undo_rounded),
        onPressed: puzzleGame.undo,
      ),
    );
  }
}
