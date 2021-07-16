import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/configs.dart';
import 'package:reorderables/reorderables.dart';

class CardPanel extends StatefulWidget {
  final List<dynamic> cardLists;
  final bool isMyCard;
  final Function(int, bool) onTap;
  final Function(int, int) onReorder;
  final int selectedCard;
  final bool isReorderable;

  CardPanel({
    Key key,
    @required this.cardLists,
    @required this.onTap,
    @required this.selectedCard,
    @required this.isReorderable,
    this.onReorder,
    this.isMyCard = false
  }) : super(key: key);

  final List<dynamic> cardList;
  final Color cardColor;
  final bool isMyCard;
  final Function(int, bool) onTap;
  final Function(int, int) onReorder;
  final int selectedCard;
  final bool reorderable;
  @override
  _CardPanelState createState() => _CardPanelState();
}

class _CardPanelState extends State<CardPanel> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isReorderable) {
      return ReorderableWrap(
        spacing: 8.0,
        runSpacing: 16.0,
        padding: const EdgeInsets.all(8),
        crossAxisAlignment: WrapCrossAlignment.center,
        onReorder: widget.onReorder,
        children: _buildCards(),
      );
    } else {
      return Wrap(
        spacing: 8.0,
        runSpacing: 16.0,
        children: _buildCards(),
      );
    }
  }

  List<Widget> _buildCards() {
    double cardWidth = GAMEBOARD_MAX_WIDTH * 0.12;
    double cardHeight = cardWidth * 1.3;
    List<Widget> res = [];
    Image cardImage;
    String ImageNumber;

    for (var i = 0; i < widget.cardLists.length; i++) {
      String cardNum = '';
      Widget cardElement;
      double cardRotation = 0.8;
      Color bgColor = Colors.black;
      Color textColor = Colors.white;
      double scale = 1;
      Border borderStyle;
      ImageNumber = (i + 1).toString() + '.png';

      // style of cards are open
      if (widget.cardLists[i]['show'] == 1) {
        cardRotation = 0;
      }

      // TODO Wei: change to card back
      // TODO Xiang: Change the back-end code for color 'white' and 'black'
      // 'white' for blue, 'black' for yellow
      // card color
      if (widget.cardLists[i]['color'] == 'white') {
        // bgColor = Colors.white;
        // textColor = Colors.black;
        cardImage = Image.asset("assets/cards-ui/blueback.png");

        // show revealed cards and own cards
        if (widget.cardLists[i]['show'] == 1 || widget.isMyCard) {
          cardImage = Image.asset("assets/cards-ui/b" + ImageNumber);
        }
      } else if (widget.cardLists[i]['color'] == 'black') {
        cardImage = Image.asset("assets/cards-ui02/yellowback.png");

        if (widget.cardLists[i]['show'] == 1 || widget.isMyCard) {
          cardImage = Image.asset("assets/cards-ui02/y" + ImageNumber);
        }
      }

      // show number on the card or not
      // if (widget.cardLists[i]['show'] == 1 || widget.isMyCard) {
      //   cardNum = widget.cardLists[i]['display_str'];
      // }

      // TODO Wei: new style
      // card style when card is selected
      if (widget.selectedCard == i) {
        scale = 1.3;
        borderStyle = Border.all(color: Colors.yellow, width: 2);
      }

      cardElement = Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.01)
          ..rotateX(cardRotation)
          ..scale(scale),
        child: GestureDetector(
          onTap: () => {widget.onTap(i, widget.isMyCard)},
          child: Container(
            width: cardWidth,
            height: cardHeight,
            // decoration: BoxDecoration(color: bgColor, border: borderStyle),
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(
              // child: Text(
              //   cardNum,
              //   style: TextStyle(fontSize: 24, color: textColor),
              // ),
              child: cardImage,
            ),
          ),
        ),
      );
      res.add(cardElement);
    }

    return res;
  }
}
