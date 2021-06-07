import 'package:flutter/material.dart';
import '../networking/GameCommunication.dart';
import './components/Cards.dart';

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
        print(message["data"]);
        // List<List<int>> _data = new List<List<int>>.from(message["data"]);
        opponentsCard =
            new List<dynamic>.from(message["data"]['opponentsCard']);
        myCard = new List<dynamic>.from(message["data"]['myCard']);
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
        // var data = (message["data"] as String).split(';');
        // grid[int.parse(data[0])] = data[1];
        // Force rebuild
        setState(() {});
        break;
    }
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

  Widget _buildInstruction(String gameHints) {
    return Container(
      child: Text(gameHints),
    );
  }

  Widget _buildCards() {
    return Expanded(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Cards(cardList: opponentsCard),
        // Cards(cardList: allCardValue, cardColor: Colors.grey),
        Cards(
          cardList: myCard,
          isMyCard: true,
        ),
      ],
    ));
  }
}
