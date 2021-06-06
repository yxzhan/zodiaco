import 'package:flutter/material.dart';

class Cards extends StatelessWidget {
  final List<int> cardList;
  Color cardColor;

  Cards({
    Key key,
    @required this.cardList,
    this.cardColor = Colors.yellow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var rowSize = (cardList.length ~/ 2).toInt();
    var row1 = cardList.sublist(0, rowSize);
    var row2 = cardList.sublist(rowSize);
    return Column(children: <Widget>[
      Container(
        height: 80,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        // decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _cardRow(row1, cardColor)),
      ),
      Container(
        height: 80,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        // decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _cardRow(row2, cardColor)),
      ),
    ]);
  }

  List<Widget> _cardRow(List<int> _cardsRow, Color cardColor) {
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
  }
}
