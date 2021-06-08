import 'package:flutter/material.dart';
import '../networking/GameCommunication.dart';
import './components/Cards.dart';
import './components/SelectPanel.dart';

class GamePage extends StatefulWidget {
  GamePage({
    Key key,
    this.playerName,
    this.opponentName,
  }) : super(key: key);

  ///
  /// Name of the players
  ///
  final String opponentName;
  final String playerName;

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<dynamic> opponentsCard = [];
  List<dynamic> myCard = [];
  String gameHints = '';
  int opponentSelectedCard = -1;
  int selfSelectedCard = -1;
  bool isMyTurn = true;
  bool showSkipButton = false;

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
      /// The opponent played a move.
      /// So record it and rebuild the board
      ///
      case 'cards_update':
        opponentsCard =
            new List<dynamic>.from(message["data"]['opponentsCard']);
        myCard = new List<dynamic>.from(message["data"]['myCard']);
        setState(() {});
        break;

      case 'switch_turn':
        isMyTurn = message["data"];
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
        setState(() {});
        break;

      ///
      /// The opponent played a move.
      /// So record it and rebuild the board
      ///
      // case 'play':
      //   // var data = (message["data"] as String).split(';');
      //   // grid[int.parse(data[0])] = data[1];

      //   // Force rebuild
      //   setState(() {});
      //   break;

      case 'gameover':
        setState(() {});
        break;
    }
  }

  void onCardTap(int index, bool isMyCard) {
    if (!isMyTurn) return;

    if (!isMyCard) {
      if (opponentsCard[index]['show'] == 1) return;
      selfSelectedCard = selfSelectedCard != index ? index : -1;
      setState(() {});

      game.send('select_card', '${selfSelectedCard}');
    } else {
      game.send('punish', '${index}');
    }
  }

  void sendGuess(int guessNum) {
    if (!isMyTurn) return;
    game.send('play', '${selfSelectedCard},${guessNum}');
    selfSelectedCard = -1;
    setState(() {});
  }

  void skipRound() {
    game.send('skip', '');
    selfSelectedCard = -1;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('GameBoard'),
        ),
        body: SafeArea(
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person),
                  Text(
                    widget.opponentName,
                  )
                ],
              ),
              _buildCards(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person),
                  Text(
                    widget.playerName,
                  )
                ],
              ),
            ],
          )),
        ));
  }

  Widget _buildInstruction() {
    return Container(
      child: Text(gameHints),
    );
  }

  Widget _buildSkip() {
    if (!showSkipButton) {
      return Container();
    }
    return Container(
        child: ElevatedButton(
      onPressed: skipRound,
      child: new Text('Skip'),
    ));
  }

  Widget _buildSelectPanel() {
    if (selfSelectedCard == -1) {
      return Container();
    }
    return SelectPanel(callback: sendGuess);
  }

  Widget _buildCards() {
    return Expanded(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Cards(
          cardList: opponentsCard,
          onTap: onCardTap,
          selectedCard: selfSelectedCard,
          isMyCard: false,
        ),
        _buildSelectPanel(),
        _buildInstruction(),
        _buildSkip(),
        Cards(
          cardList: myCard,
          onTap: onCardTap,
          selectedCard: opponentSelectedCard,
          isMyCard: true,
        ),
      ],
    ));
  }
}
