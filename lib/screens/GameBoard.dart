import 'package:flutter/material.dart';

class GameBoard extends StatefulWidget {
  final String playerName;

  GameBoard({
    Key key,
    @required this.playerName,
  }) : super(key: key);

  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  @override
  Widget build(BuildContext context) {
    // final playerName = GameBoard.playerName;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'gameBoard',
            ),
          ],
        ),
      ),
    );
  }
}
