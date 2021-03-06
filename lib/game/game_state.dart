import 'package:aandd_puzzle/game/board_coordinate.dart';
import 'package:aandd_puzzle/utils/stack.dart';
import 'package:equatable/equatable.dart';

/// State of the game.
///
/// Keeps all moves of a user in "history" and count every move.
class GameState {
  int _totalSteps = 0;
  Stack<GameMove> state = Stack();
  bool win = false;

  int get totalSteps => _totalSteps;
  int get step => state.length;

  void keep(GameMove move) {
    _totalSteps++;
    state.push(move);
  }

  GameMove? revert() {
    return state.length > 0 ? state.pop() : null;
  }

  void clear() {
    state.clear();
    _totalSteps = 0;
  }
}

/// Represents tile movement
///
/// [before] shows tile coordinate before moving to the empty slot
/// [after] shows coordinate of where tile goes
class GameMove extends Equatable {
  final BoardCoordinate before;
  final BoardCoordinate after;

  const GameMove({
    required this.before,
    required this.after,
  });

  @override
  List<Object?> get props => [
        before,
        after,
      ];

  @override
  bool get stringify => true;
}
