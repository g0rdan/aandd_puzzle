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

  List<BoardCoordinate> getNeighbors({
    required int boardWidth,
    required int boardHeigth,
  }) {
    return [
      BoardCoordinate(x: x - 1, y: y),
      BoardCoordinate(x: x, y: y - 1),
      BoardCoordinate(x: x + 1, y: y),
      BoardCoordinate(x: x, y: y + 1),
    ]
        .where(
          (neibor) =>
              neibor.x >= 0 &&
              neibor.y >= 0 &&
              neibor.x < boardWidth &&
              neibor.y < boardHeigth,
        )
        .toList();
  }

  BoardCoordinate copy() {
    return BoardCoordinate(x: x, y: y);
  }
}
