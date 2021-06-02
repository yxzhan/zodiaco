import 'package:flutter/material.dart';
import 'GameBoard.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _startGame() {
    print('Start Game');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GameBoard(playerName: 'player1')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Zodiaco',
            ),
            TextField(
              obscureText: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your name',
              ),
            ),
            ElevatedButton(
              onPressed: _startGame,
              child: Text('Start'),
            ),
          ],
        ),
      ),
    );
  }
}
