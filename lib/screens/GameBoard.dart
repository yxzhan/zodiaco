import 'package:flutter/material.dart';
import 'components/Cards.dart';
import '../networking/GameManager.dart';

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
  final GameManager gameManager = new GameManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('GameBoard'),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: [
                  Text(
                    'Opponent\'s name:' + widget.playerName,
                  ),
                  Cards(cardList: gameManager.opponentsCard),
                ],
              ),
              Cards(cardList: gameManager.allCardValue, cardColor: Colors.grey),
              Column(children: [
                Cards(cardList: gameManager.myCard),
                Text(
                  'Your Name:' + widget.playerName,
                ),
              ])
            ],
          ),
        ));
  }
}
