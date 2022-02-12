import 'package:equatable/equatable.dart';

class GameConfig extends Equatable {
  final int width;
  final int height;
  final String gameImage;

  const GameConfig({
    required this.width,
    required this.height,
    required this.gameImage,
  });

  GameConfig copyWith({
    int? width,
    int? height,
    String? gameImage,
  }) {
    return GameConfig(
      width: width ?? this.width,
      height: height ?? this.height,
      gameImage: gameImage ?? this.gameImage,
    );
  }

  @override
  List<Object?> get props => [
        width,
        height,
        gameImage,
      ];
}
