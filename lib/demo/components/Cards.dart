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
    const rowMargin = EdgeInsets.symmetric(vertical: 8.0);
    var rowSize = (cardList.length ~/ 2).toInt();
    var row1 = cardList.sublist(0, rowSize);
    var row2 = cardList.sublist(rowSize);
    return Column(children: <Widget>[
      Container(
        margin: rowMargin,
        // decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _cardRow(context, row1, cardColor)),
      ),
      Container(
        margin: rowMargin,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _cardRow(context, row2, cardColor)),
      ),
    ]);
  }

  List<Widget> _cardRow(
      BuildContext context, List<int> _cardsRow, Color cardColor) {
    double cardHeight =
        (MediaQuery.of(context).size.height - AppBar().preferredSize.height) *
            0.1;
    // double cardWidth = MediaQuery.of(context).size.width * 0.12;
    double cardWidth = cardHeight * 0.71;
    List<Widget> res = [];
    for (var i = 0; i < _cardsRow.length; i++) {
      res.add(Container(
        width: cardWidth,
        height: cardHeight,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        color: cardColor,
        child: Center(child: Text('${_cardsRow[i]}')),
      ));
    }
    return res;
  }
}
