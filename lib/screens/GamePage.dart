import 'package:flutter/material.dart';
import '../networking/GameCommunication.dart';
import './components/Cards.dart';
import './components/SelectPanel.dart';
import '../utils/Configs.dart';
import 'dart:convert';

class GamePage extends StatefulWidget {
  GamePage({
    Key key,
    this.myName,
    this.opponentName,
  }) : super(key: key);

  ///
  /// Name of the players
  ///
  final String opponentName;
  final String myName;

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
    game.send('resign', '');
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
        Navigator.of(context).pop();
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
    // TODO Wei: scale up the selected card if it is not my turn
    if (!isMyTurn) return;

    // My turn
    // Select an opponent's card
    if (!isMyCard) {
      // If the selected card has been shown or I am being punished
      if (opponentsCards[index]['show'] == 1 || isPunishing) return;

      selfSelectedCard = selfSelectedCard != index ? index : -1;
      setState(() {});

      game.send('select_card', '${selfSelectedCard}');

    // Select my own card for punishing
    } else if (isPunishing) {
      game.send('punish', '${index}');
    }
  }

  void sendGuess(int guessNum) {
    if (!isMyTurn || isPunishing) return;
    game.send('play', '${selfSelectedCard},${guessNum}');
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
  }

  void onReorder(int oldIndex, int newIndex) {
    var card = myCards.elementAt(oldIndex);
    if (card['value'] != 1) return;
    myCards.removeAt(oldIndex);
    myCards.insert(newIndex, card);
    game.send('on_reorder', json.encode(myCards));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GameBoard'),
      ),
      body: SafeArea(
        child: Container(
          color: GAMEBOARD_COLOR,
          child: Center(
            child: Container(
              width: GAMEBOARD_MAX_WIDTH,
              color: GAMEBOARD_COLOR,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildPlayerInfo(widget.opponentName, !isMyTurn),
                  _buildGameBoard(),
                  _buildPlayerInfo(widget.myName, isMyTurn)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerInfo(String name, bool isPlaying) {
    Widget playingSign = Container();
    if (isPlaying) {
      // playingSign = LoadingCircle(
      //   size: 10.0,
      //   duration: 2,
      // );
      playingSign = Text('\'s turn.');
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.person),
        Text(
          name,
        ),
        playingSign
      ],
    );
  }

  Widget _buildGameBoard() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Cards(
            cardLists: opponentsCards,
            onTap: onCardTap,
            selectedCard: selfSelectedCard,
            isMyCard: false,
            isReorderable: false,
          ),
          _buildSelectPanel(),
          _buildInstruction(),
          _buildButtons(),
          Cards(
            cardLists: myCards,
            onTap: onCardTap,
            selectedCard: opponentSelectedCard,
            isMyCard: true,
            isReorderable: isReorderable,
            onReorder: onReorder,
          ),
        ],
      ),
    );
  }

  Widget _buildInstruction() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        child: Text(
          gameHints,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildSelectPanel() {
    if (selfSelectedCard == -1) {
      return Container();
    }
    return SelectPanel(callback: sendGuess);
  }

  Widget _buildButtons() {
    if (showRestartButton) {
      return Container(
        child: ElevatedButton(
          onPressed: restartGame,
          child: new Text('Restart'),
        ),
      );
    }
    if (!showSkipButton) {
      return Container();
    }
    return Container(
      child: ElevatedButton(
        onPressed: skipRound,
        child: new Text('Skip'),
      ),
    );
  }
}
