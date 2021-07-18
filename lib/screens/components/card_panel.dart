import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/configs.dart';
import 'package:reorderables/reorderables.dart';

class CardPanel extends StatefulWidget {
  final List<dynamic> cardLists;
  final bool isMyCard;
  final bool isMyTurn;
  final Function(int, bool) onTap;
  final Function(int, int) onReorder;
  final int selectedCard;
  final bool isReorderable;
  final bool isPunishing;

  CardPanel({
    Key key,
    @required this.cardLists,
    @required this.onTap,
    @required this.selectedCard,
    @required this.isReorderable,
    this.onReorder,
    this.isMyCard = false,
    this.isMyTurn,
    this.isPunishing,
  }) : super(key: key);

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
    List<dynamic> styles = _buildInteractiveHint();

    return Card(
      shape: styles[0],
      color: styles[1],
      shadowColor: Colors.black,
      elevation: 10.0,
      // margin: EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
        child: _buildWrap(),
      ),
    );
  }

  // color, shadowColor, elevation in Card
  List<dynamic> _buildInteractiveHint() {
    if (widget.isMyTurn) {
      if (widget.isPunishing) {
        // my turn on choosing, highlight my cards
        if (widget.isMyCard) {
          return [
            new RoundedRectangleBorder(
              side: new BorderSide(
                color: Color.fromARGB(255, 142, 65, 99),
                width: 4.0,
              ),
              borderRadius: BorderRadius.circular(4.0),
            ),
            Color.fromARGB(255, 227, 239, 248)
          ];
        }
      } else {
        // my turn on being punished, highlight opponent's cards
        if (!widget.isMyCard) {
          return [
            new RoundedRectangleBorder(
              side: new BorderSide(
                color: Color.fromARGB(255, 142, 65, 99),
                width: 4.0,
              ),
              borderRadius: BorderRadius.circular(4.0),
            ),
            Color.fromARGB(255, 227, 239, 248)
          ];
        }
      }
    }
    // not my turn, highlight nothing
    return [null, Colors.white24];
  }

  Widget _buildWrap() {
    if (widget.isReorderable) {
      return ReorderableWrap(
        spacing: 16.0,
        runSpacing: 8.0,
        // padding: const EdgeInsets.all(8),
        crossAxisAlignment: WrapCrossAlignment.center,
        onReorder: widget.onReorder,
        children: _buildCards(),
      );
    } else {
      // TODO: effect
      // if (widget.isMyTurn){
      //   Widget background;
      // }

      return Wrap(
        spacing: 16.0,
        runSpacing: 8.0,
        alignment: WrapAlignment.center,
        children: _buildCards(),
      );
    }
  }

  List<Widget> _buildCards() {
    double cardWidth = GAMEBOARD_MAX_WIDTH * 0.12;
    double cardHeight = cardWidth * 1.3;
    List<Widget> res = [];
    String imageDir;
    String imageNumber;

    for (var i = 0; i < widget.cardLists.length; i++) {
      Widget cardElement;
      double cardRotation = 0.8;
      double scale = 1;
      Border borderStyle;
      imageNumber = widget.cardLists[i]['display_str'];

      // style of cards are open
      if (widget.cardLists[i]['show'] == 1 || widget.isReorderable) {
        cardRotation = 0;
      }

      // TODO Xiang: Change the back-end code for color 'white' and 'black'
      // 'white' for blue, 'black' for yellow
      // card color
      if (widget.cardLists[i]['color'] == 'white') {
        imageDir = CARDS_UI_DIR + 'blueback';

        // show revealed cards and own cards
        if (widget.cardLists[i]['show'] == 1 || widget.isMyCard) {
          imageDir = CARDS_UI_DIR + 'b' + imageNumber;
        }
      } else if (widget.cardLists[i]['color'] == 'black') {
        imageDir = CARDS_UI_DIR + 'yellowback';

        if (widget.cardLists[i]['show'] == 1 || widget.isMyCard) {
          imageDir = CARDS_UI_DIR + 'y' + imageNumber;
        }
      }

      // TODO Wei: new style
      // card style when card is selected
      if (widget.selectedCard == i) {
        scale = 1.3;
        borderStyle = Border.all(color: Colors.white, width: 2);
      }

      cardElement = Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.01)
          ..rotateX(cardRotation)
          ..scale(scale),
        child: Card(
          elevation: 10.0,
          child: GestureDetector(
            onTap: () => {widget.onTap(i, widget.isMyCard)},
            child: Container(
              width: cardWidth,
              // height: cardHeight,
              decoration: BoxDecoration(border: borderStyle),
              // margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Image.asset(imageDir + '.png'),
            ),
          ),
        ),
      );
      res.add(cardElement);
    }

    return res;
  }
}
