import 'package:equatable/equatable.dart';

class GameConfig extends Equatable {
  final int width;
  final int height;

  const GameConfig({
    required this.width,
    required this.height,
  });

  GameConfig copyWith({
    int? width,
    int? height,
  }) {
    return GameConfig(
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  @override
  List<Object?> get props => [
        width,
        height,
      ];
}
