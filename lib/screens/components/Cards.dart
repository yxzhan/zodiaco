import 'package:flutter/material.dart';

class Cards extends StatelessWidget {
  Cards({
    Key key,
    @required this.cardList,
    @required this.onTap,
    @required this.selectedCard,
    this.cardColor = Colors.yellow,
    this.isMyCard = false,
  }) : super(key: key);

  final List<dynamic> cardList;
  final Color cardColor;
  final bool isMyCard;
  final Function(int, bool) onTap;
  final int selectedCard;
  int rowSize = 0;

  @override
  Widget build(BuildContext context) {
    const rowMargin = EdgeInsets.symmetric(vertical: 8.0);
    rowSize = (cardList.length ~/ 2).toInt();
    var row1 = cardList.sublist(0, rowSize);
    var row2 = cardList.sublist(rowSize);
    return Column(children: <Widget>[
      Container(
        margin: rowMargin,
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
    ]);
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

      if (_cardsRow[i]['show'] == 1) {
        cardRotation = 0;
      }
      if (_cardsRow[i]['show'] == 1 || isMyCard) {
        cardNum = _cardsRow[i]['value'].toString();
      }
      if (selectedCard == originIndex) {
        borderColor = Colors.red;
      }
      cardElement = Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.01)
            ..rotateX(cardRotation),
          child: GestureDetector(
              onTap: () => {onTap(originIndex, isMyCard)},
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
}
