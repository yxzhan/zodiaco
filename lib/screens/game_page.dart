import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zodiaco/screens/components/Button.dart';
import '../networking/game_communication.dart';
import './components/card_panel.dart';
import './components/selection_panel.dart';
import '../utils/configs.dart';
import 'dart:convert';

class GamePage extends StatefulWidget {
  final String playerName;
  final String opponentName;

  GamePage({Key key, this.playerName, this.opponentName}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<dynamic> opponentsCards = [];
  List<dynamic> myCards = [];
  String gameHints = '';
  int opponentSelectedCard = -1;
  int selfSelectedCard = -1;
  bool isMyTurn = false;
  bool showSkipButton = false;
  bool showRestartButton = false;
  bool isPunishing = false;
  bool isReorderable = false;

  @override
  void initState() {
    super.initState();

    ///
    /// Ask to be notified when a message from the server
    /// comes in.
    ///
    game.addListener(_onAction);
    game.send('ready', '');
  }

  @override
  void dispose() {
    game.removeListener(_onAction);
    super.dispose();
  }

  /// ---------------------------------------------------------
  /// The opponent took an action
  /// Handler of these actions
  /// ---------------------------------------------------------
  _onAction(message) {
    switch (message["action"]) {

      ///
      /// The opponent resigned, so let's leave this screen
      ///
      case 'resigned':
        showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: const Text('Player Left!'),
                  content: Text(widget.opponentName + ' left the game.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ));
        break;

      ///
      /// Allow player to place special card to any position
      ///
      case 'allow_reorder':
        isReorderable = message["data"];
        break;

      ///
      /// The opponent played a move.
      /// So record it and rebuild the board
      ///
      case 'cards_update':
        opponentsCards =
            new List<dynamic>.from(message["data"]['opponentsCard']);
        myCards = new List<dynamic>.from(message["data"]['myCard']);
        showRestartButton = false;
        setState(() {});
        break;

      case 'switch_turn':
        isMyTurn = message["data"];
        isPunishing = false;
        selfSelectedCard = -1;
        setState(() {});
        break;

      case 'select_card':
        opponentSelectedCard = int.parse(message["data"]);
        setState(() {});
        break;

      case 'hint_update':
        gameHints = message["data"];
        setState(() {});
        break;

      case 'show_skip':
        showSkipButton = message["data"];
        if (showSkipButton) {
          selfSelectedCard = -1;
        }
        setState(() {});
        break;

      case 'punish':
        isPunishing = true;
        selfSelectedCard = -1;
        setState(() {});
        break;

      case 'gameover':
        print('gameover');
        selfSelectedCard = -1;
        showSkipButton = false;
        showRestartButton = true;
        setState(() {});
        break;
    }
  }

  void onCardTap(int index, bool isMyCard) {
    if (!isMyTurn) return;

    if (!isMyCard) {
      if (opponentsCards[index]['show'] == 1 || isPunishing) return;
      selfSelectedCard = selfSelectedCard != index ? index : -1;
      setState(() {});

      game.send('select_card', '$selfSelectedCard');
    } else if (isPunishing) {
      game.send('punish', '$index');
    }
  }

  void sendGuess(int guessNum) {
    if (!isMyTurn || isPunishing) return;
    game.send('play', '$selfSelectedCard,$guessNum');
    // selfSelectedCard = -1;
    // setState(() {});
  }

  void skipRound() {
    game.send('skip', '');
    selfSelectedCard = -1;
    showSkipButton = false;
    setState(() {});
  }

  void restartGame() {
    game.send('ready', '');
    this.showRestartButton = false;
    setState(() {});
  }

  void rematchPlayer() {
    Navigator.pop(context, 'rematch');
  }

  void onReorder(int oldIndex, int newIndex) {
    var card = myCards.elementAt(oldIndex);
    if (card['value'] != 1) return;
    myCards.removeAt(oldIndex);
    myCards.insert(newIndex, card);
    game.send('on_reorder', json.encode(myCards));
    setState(() {});
  }

  void quitGame() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(38, 50, 56, 1),
      // appBar: AppBar(
      //   title: Text('GameBoard'),
      // ),
      body: SafeArea(
        child: Container(
          // color: GAMEBOARD_COLOR,
          decoration: BoxDecoration(
            // a background image
            image: DecorationImage(
              image: AssetImage(IMAGE_DIR + 'gamebg.png'),
              // cover the entire screen -> a full background image
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Container(
              // TODO: change the game board size
              width: GAMEBOARD_MAX_WIDTH,
              // width: 400.0,
              // color: GAMEBOARD_COLOR,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildPlayerInfo(
                    widget.opponentName,
                    !isMyTurn,
                    _buildQuitButton(),
                    Container(),
                  ),
                  _buildGameBoard(),
                  _buildPlayerInfo(
                    widget.playerName,
                    isMyTurn,
                    Container(),
                    _buildQuitButton(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerInfo(
      String name, bool isPlaying, Widget leftWidget, Widget rightWidget) {
    // Widget playingSign = Container();
    Color color = Colors.grey;
    if (isPlaying) {
      // playingSign = Text('\'s turn');
      color = Colors.white;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          leftWidget,
          Row(
            // mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.person, color: color),
              Text(name, style: TextStyle(color: color)),
              // playingSign
            ],
          ),
          rightWidget,
        ],
      ),
    );
  }

  Widget _buildQuitButton() {
    return IconButton(
      onPressed: quitGame,
      constraints: BoxConstraints(),
      // remove all the padding
      icon: Icon(Icons.arrow_back),
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
    );
  }

  Widget _buildGameBoard() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CardPanel(
            cardLists: opponentsCards,
            onTap: onCardTap,
            selectedCard: selfSelectedCard,
            isMyTurn: isMyTurn,
            isMyCard: false,
            isReorderable: false,
            isPunishing: isPunishing,
          ),
          _buildInfoPanel(),
          CardPanel(
            cardLists: myCards,
            onTap: onCardTap,
            selectedCard: opponentSelectedCard,
            isMyTurn: isMyTurn,
            isMyCard: true,
            isReorderable: isReorderable,
            onReorder: onReorder,
            isPunishing: isPunishing,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPanel() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSelectionPanel(),
        _buildInstruction(),
        _buildButtons(),
      ],
    );
  }

  Widget _buildSelectionPanel() {
    if (selfSelectedCard == -1) {
      return Container();
    }
    return SelectionPanel(
      selectedCard: selfSelectedCard,
      cardLists: opponentsCards,
      callback: sendGuess,
    );
  }

  Widget _buildInstruction() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Text(
          gameHints,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20.0, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildButtons() {
    if (showRestartButton) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Button(text: 'Play Again', onPressed: restartGame),
          Button(text: 'Next Game', onPressed: rematchPlayer),
        ],
      );
    }
    if (!showSkipButton) {
      return Container();
    }
    return Container(
      child: Button(text: 'Skip', onPressed: skipRound),
    );
  }
}
