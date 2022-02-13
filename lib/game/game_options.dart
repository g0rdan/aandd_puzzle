import 'package:aandd_puzzle/game/main_game.dart';
import 'package:flutter/material.dart';

class GameOptions extends StatelessWidget {
  const GameOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select An Image to use for your game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: [
                  const _GameImage(asset: 'dash_squared_small.png'),
                  const _GameImage(asset: 'dash_version_squared_small.png'),
                  const _GameImage(asset: 'flutter_logo.png'),
                ]
                    .map(
                      (image) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          child: Image.asset(
                            'assets/images/${image.asset}',
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width / 3,
                            height: MediaQuery.of(context).size.width / 3,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MainGame(
                                  gameImage: image.asset,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GameImage {
  final String asset;

  const _GameImage({
    required this.asset,
  });
}
