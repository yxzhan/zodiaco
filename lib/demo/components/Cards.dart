import 'package:flutter/material.dart';
import '../../networking/GameCommunication.dart';
import './SelectPanel.dart';

// import 'dart:math';

class Cards extends StatefulWidget {
  Cards({
    Key key,
    @required this.cardList,
    this.cardColor = Colors.yellow,
    this.isMyCard = false,
  }) : super(key: key);

  final List<dynamic> cardList;
  final Color cardColor;
  final bool isMyCard;

  @override
  _CardsState createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  int selectedCards = -1;
  int rowSize = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const rowMargin = EdgeInsets.symmetric(vertical: 8.0);
    rowSize = (widget.cardList.length ~/ 2).toInt();
    var row1 = widget.cardList.sublist(0, rowSize);
    var row2 = widget.cardList.sublist(rowSize);
    return Column(children: <Widget>[
      Container(
        margin: rowMargin,
        // decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _cardRow(context, row1, 1)),
      ),
      Container(
        margin: rowMargin,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _cardRow(context, row2, 2)),
      ),
      _buildSelectPanel(),
    ]);
  }

  Widget _buildSelectPanel() {
    if (selectedCards == -1 || widget.isMyCard) {
      return Container();
    }
    return SelectPanel(callback: sendGuess);
  }

  List<Widget> _cardRow(
      BuildContext context, List<dynamic> _cardsRow, int rowIndex) {
    double cardHeight =
        (MediaQuery.of(context).size.height - AppBar().preferredSize.height) *
            0.09;
    double cardWidth = cardHeight * 0.71;
    List<Widget> res = [];
    for (var i = 0; i < _cardsRow.length; i++) {
      String cardNum = '';
      Widget cardElement;
      double cardRotation = 0.7;
      Color borderColor = Colors.black;
      int originIndex = i + (rowIndex - 1) * rowSize;

      if (_cardsRow[i]['show'] == 1 || widget.isMyCard) {
        cardNum = _cardsRow[i]['value'].toString();
      }
      if (_cardsRow[i]['show'] == 1) {
        cardRotation = 0;
      }
      if (selectedCards == originIndex && !widget.isMyCard) {
        borderColor = Colors.red;
      }
      cardElement = Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.01)
            ..rotateX(cardRotation),
          child: GestureDetector(
              onTap: () => {onCardTap(originIndex)},
              child: Container(
                width: cardWidth,
                height: cardHeight,
                decoration:
                    BoxDecoration(border: Border.all(color: borderColor)),
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                // color: cardColor,
                child: Center(child: Text(cardNum)),
              )));
      res.add(cardElement);
    }
    return res;
  }

  void onCardTap(int originIndex) {
    if (widget.cardList[originIndex]['show'] == 1) return;
    selectedCards = selectedCards != originIndex ? originIndex : -1;
    setState(() {});
    // int guessNum = 3;
    // sendGuess(originIndex, guessNum);
  }

  void sendGuess(int guessNum) {
    game.send('play', '${selectedCards},${guessNum}');
    selectedCards = -1;
    setState(() {});
  }
}
