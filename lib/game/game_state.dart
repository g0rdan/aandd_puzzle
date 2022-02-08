import 'package:aandd_puzzle/game/board_coordinate.dart';
import 'package:aandd_puzzle/utils/stack.dart';
import 'package:equatable/equatable.dart';

class GameState {
  int _totalSteps = 0;
  Stack<GameMove> state = Stack();

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
