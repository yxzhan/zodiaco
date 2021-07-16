import 'package:flutter/material.dart';
import '../../utils/configs.dart';

class SelectionPanel extends StatelessWidget {
  final int selectedCard;
  final Function(int) callback;
  final List<dynamic> allCardValue = [for (var i = 1; i < 13; i += 1) i];

  SelectionPanel({Key key, this.selectedCard, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
        child: Wrap(
          spacing: 0,
          runSpacing: 16,
          children: _buildCards(context),
        ),
      ),
    );
  }

  List<Widget> _buildCards(BuildContext context) {
    double cardWidth = GAMEBOARD_MAX_WIDTH * 0.12;
    double cardHeight = cardWidth * 1.2;

    List<Widget> res = [];
    for (var i = 0; i < allCardValue.length; i++) {
      Widget cardElement;
      String cardNum = allCardValue[i] == 1 ? 'X' : allCardValue[i].toString();
      cardElement = GestureDetector(
        onTap: () => {callback(allCardValue[i])},
        child: Container(
          width: cardWidth,
          height: cardHeight,
          decoration:
              BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Center(
            child: Text(
              cardNum,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      );
      res.add(cardElement);
    }
    return res;
  }
}
