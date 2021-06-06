import 'package:flutter/material.dart';
import '../networking/GameCommunication.dart';
import './components/Cards.dart';
import '../networking/GameManager.dart';

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
  final GameManager gameManager = new GameManager();

  @override
  void initState() {
    super.initState();

    ///
    /// Ask to be notified when a message from the server
    /// comes in.
    ///
    game.addListener(_onAction);
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
        Navigator.of(context).pop();
        break;

      ///
      /// The opponent played a move.
      /// So record it and rebuild the board
      ///
      case 'play':
        var data = (message["data"] as String).split(';');
        // grid[int.parse(data[0])] = data[1];

        // Force rebuild
        setState(() {});
        break;
    }
  }

  /// ---------------------------------------------------------
  /// This player resigns
  /// We need to send this notification to the other player
  /// Then, leave this screen
  /// ---------------------------------------------------------
  // _doResign() {
  //   game.send('resign', '');
  //   Navigator.of(context).pop();
  // }

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
              Text(
                'Opponent: ' + widget.opponentName,
              ),
              _buildGrid(),
              Text(
                'Your Name: ' + widget.playerName,
              ),
            ],
          )),
        ));
  }

  Widget _buildInstruction(String gameHints) {
    return Container(
      child: Text(gameHints),
    );
  }

  Widget _buildGrid() {
    return Expanded(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Cards(cardList: gameManager.opponentsCard),
        Cards(cardList: gameManager.allCardValue, cardColor: Colors.grey),
        Cards(cardList: gameManager.myCard),
      ],
    ));
  }
}
