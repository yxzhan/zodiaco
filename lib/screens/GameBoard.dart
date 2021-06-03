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
  List<int> allCards = [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9
  ];

  List<List<int>> _suffleCards() {
    List<int> res = List.castFrom(allCards);
    res.shuffle();
    int halfSize = (res.length / 2).toInt();
    return [res.sublist(0, halfSize), res.sublist(halfSize)];
  }

  @override
  Widget build(BuildContext context) {
    var _cards = _suffleCards();
    print(_cards);
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
                  _buildCards(_cards[0]),
                ],
              ),
              _buildCards([for (var i = 0; i < 10; i += 1) i],
                  cardColor: Colors.grey),
              Column(children: [
                _buildCards(_cards[1]),
                Text(
                  'Your Name:' + widget.playerName,
                ),
              ])
            ],
          ),
        ));
  }

  Widget _buildCards(List<int> _cards, {Color cardColor = Colors.yellow}) {
    var rowSize = (_cards.length ~/ 2).toInt();
    var row1 = _cards.sublist(0, rowSize);
    var row2 = _cards.sublist(rowSize);
    return Column(children: <Widget>[
      Container(
        height: 80,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        // decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: buildCard(row1, cardColor)),
      ),
      Container(
        height: 80,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        // decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: buildCard(row2, cardColor)),
      ),
    ]);
  }

  Widget _buildCard(int index, List<int> _cardsRow, Color cardColor) {
    return Container(
      width: 50,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      color: cardColor,
      child: Center(child: Text('${_cardsRow[index]}')),
    );
  }

  List<Widget> buildCard(List<int> _cardsRow, Color cardColor) {
    List<Widget> res = [];
    for (var i = 0; i < _cardsRow.length; i++) {
      res.add(Container(
        width: 50,
        height: 80,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        color: cardColor,
        child: Center(child: Text('${_cardsRow[i]}')),
      ));
    }
    return res;
    // return Container(
    //   width: 50,
    //   margin: const EdgeInsets.symmetric(horizontal: 8.0),
    //   color: cardColor,
    //   child: Center(child: Text('${_cardsRow[index]}')),
    // );
  }
}
