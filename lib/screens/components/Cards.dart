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

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 16.0,
      children: _buildCards(context),
    );
  }

  List<Widget> _buildCards(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width * 0.12;
    double cardHeight = cardWidth * 1.3;
    List<Widget> res = [];
    for (var i = 0; i < cardList.length; i++) {
      String cardNum = '';
      Widget cardElement;
      double cardRotation = 0.8;
      Color bgColor = Colors.black;
      Color textColor = Colors.white;
      double scale = 1;

      if (cardList[i]['show'] == 1) {
        cardRotation = 0;
      }
      if (cardList[i]['color'] == 'white') {
        bgColor = Colors.white;
        textColor = Colors.black;
      }
      if (cardList[i]['show'] == 1 || isMyCard) {
        cardNum = cardList[i]['value'].toString();
      }
      if (selectedCard == i) {
        scale = 1.3;
      }
      cardElement = Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.01)
            ..rotateX(cardRotation)
            ..scale(scale),
          child: GestureDetector(
              onTap: () => {onTap(i, isMyCard)},
              child: Container(
                width: cardWidth,
                height: cardHeight,
                // decoration: BoxDecoration(
                //     border: Border.all(color: borderColor, width: borderWidth)),
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                color: bgColor,
                child: Center(
                    child: Text(
                  cardNum,
                  style: TextStyle(fontSize: 24, color: textColor),
                )),
              )));
      res.add(cardElement);
    }
    return res;
  }
}
