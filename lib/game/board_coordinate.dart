import 'package:equatable/equatable.dart';

class BoardCoordinate extends Equatable {
  final int x;
  final int y;

  const BoardCoordinate({
    required this.x,
    required this.y,
  });

  @override
  List<Object?> get props => [x, y];

  @override
  bool get stringify => true;

  List<BoardCoordinate> getNeighbors() {
    return [
      BoardCoordinate(x: x - 1, y: y),
      BoardCoordinate(x: x, y: y - 1),
      BoardCoordinate(x: x + 1, y: y),
      BoardCoordinate(x: x, y: y + 1),
    ];
  }

  BoardCoordinate copy() {
    return BoardCoordinate(x: x, y: y);
  }
}
