import 'package:flutter/material.dart';
import '../../utils/configs.dart';
import 'dart:math';

class SelectionPanel extends StatelessWidget {
  final int selectedCard;
  final List<dynamic> cardLists;
  final Function(int) callback;
  final List<dynamic> allCardValue = [for (var i = 1; i < 13; i += 1) i];

  SelectionPanel({
    Key key,
    this.selectedCard,
    this.cardLists,
    this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
        child: Wrap(
          spacing: 0,
          runSpacing: 16.0,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: _buildCards(context),
        ),
      ),
    );
  }

  List<Widget> _buildCards(BuildContext context) {
    // double cardWidth = GAMEBOARD_MAX_WIDTH * 0.12;
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = min(screenWidth, GAMEBOARD_MAX_WIDTH) * 0.12;

    double cardHeight = cardWidth * 1.2;

    String imageDir = CARDS_UI_DIR + 'b';
    if (cardLists[selectedCard]['color'] == 'black') {
      imageDir = CARDS_UI_DIR + 'y';
    }

    List<Widget> res = [];
    for (var i = 0; i < allCardValue.length; i++) {
      Widget cardElement;
      String cardNum = allCardValue[i] == 1 ? 'X' : allCardValue[i].toString();
      cardElement = GestureDetector(
        onTap: () => {callback(allCardValue[i])},
        child: Container(
          width: cardWidth,
          height: cardHeight,
          // TODO: new style when selected
          // decoration:
          //     BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Center(
            child: Image.asset(imageDir + (i + 1).toString() + '.png'),
          ),
        ),
      );
      res.add(cardElement);
    }
    return res;
  }
}
