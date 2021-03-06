import 'package:aandd_puzzle/game/game_options.dart';
import 'package:aandd_puzzle/game/game_state.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

void main() {
  final getIt = GetIt.instance;
  getIt.registerLazySingleton<GameState>(() => GameState());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'A&D puzzle game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(
        title: 'Slide puzzle game demo',
      ),
      routes: {
        'gameOptions': (_) => const GameOptions(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              color: Colors.indigo[50],
              child: const Text('Play Game'),
              onPressed: () {
                Navigator.of(context).pushNamed('gameOptions');
              },
            ),
          ],
        ),
      ),
    );
  }
}
