import 'package:flutter/material.dart';

class SelectPanel extends StatelessWidget {
  SelectPanel({Key key, this.callback}) : super(key: key);
  final Function(int) callback;

  @override
  Widget build(BuildContext context) {
    final List<dynamic> allCardValue = [for (var i = 1; i < 13; i += 1) i];
    int rowSize = (allCardValue.length ~/ 2).toInt();
    var row1 = allCardValue.sublist(0, rowSize);
    var row2 = allCardValue.sublist(rowSize);
    const rowMargin = EdgeInsets.symmetric(vertical: 8.0);
    return Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: Column(children: <Widget>[
          Container(
            margin: rowMargin,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _cardRow(context, row1)),
          ),
          Container(
            margin: rowMargin,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _cardRow(context, row2)),
          ),
        ]));
  }

  List<Widget> _cardRow(BuildContext context, List<dynamic> _cardsRow) {
    double cardHeight =
        (MediaQuery.of(context).size.height - AppBar().preferredSize.height) *
            0.08;
    double cardWidth = cardHeight * 0.71;
    List<Widget> res = [];
    for (var i = 0; i < _cardsRow.length; i++) {
      Widget cardElement;
      cardElement = GestureDetector(
          onTap: () => {callback(_cardsRow[i])},
          child: Container(
            width: cardWidth,
            height: cardHeight,
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(child: Text(_cardsRow[i].toString())),
          ));
      res.add(cardElement);
    }
    return res;
  }
}
