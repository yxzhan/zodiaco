import 'package:flutter/material.dart';
import './components/button.dart';
import '../networking/game_communication.dart';
import './game_page.dart';
import '../utils/utils.dart';
import './components/loading_circle.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String playersListLength = 'connecting to server...';
  String playerName = '';
  String gameState = '';
  static final TextEditingController _name = new TextEditingController();

  @override
  void initState() {
    super.initState();

    _name.text = randomName();

    ///
    /// Ask to be notified when messages related to the game
    /// are sent by the server
    ///
    game.addListener(_onGameDataReceived);
  }

  @override
  void dispose() {
    game.removeListener(_onGameDataReceived);
    super.dispose();
  }

  _onGameDataReceived(message) {
    print(message);
    switch (message["action"]) {
      case "matching_player":
        gameState = message["action"];
        setState(() {});
        break;

      ///
      /// Each time a new player joins, we need to
      ///   * record amount of online players
      ///
      case "players_list":
        playersListLength = message["data"].toString();
        // force rebuild
        setState(() {});
        break;

      // when matched players ready, start a new game
      case 'new_game':
        gameState = '';
        setState(() {});
        startNewGame(message["data"]);
        break;
    }
  }

  void startNewGame(String opName) async {
    final result = await Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (BuildContext context) => GamePage(
            playerName: playerName, // Name of the opponent
            opponentName: opName, // Name of the opponent
          ),
        ));
    if (result == 'rematch') {
      onPressed();
    } else {
      game.send('resign', '');
    }
  }

  void cancelMatching() {
    game.send('resign', '');
    gameState = '';
    setState(() {});
  }

  void onPressed() {
    game.send('join', _name.text);
    playerName = _name.text;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget mainUI;
    if (gameState != 'matching_player') {
      mainUI = buildLogin(context);
    } else {
      mainUI = _buildMatching();
    }
    return SafeArea(
        child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/loginbg.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: mainUI));
  }

  Widget _buildMatching() {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(30),
              child: LoadingCircle(),
            ),
            Text(
              'Welcome ' + game.playerName + '\nMatching Player...',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Kefa',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Padding(
                padding: const EdgeInsets.all(20),
                child: Button(text: 'Cancel', onPressed: cancelMatching)),
          ]),
    );
  }

  Widget buildLogin(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraint.maxHeight),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 60,
                width: 100,
              ),
              //space for gif
              Center(
                  child: Container(
                      height: 200,
                      width: 200,
                      child: Image.asset("assets/12anim.gif"))),

              //just for vertical spacing
              // SizedBox(
              //   height: 5,
              //   width: 10,
              // ),
              Text(
                'Online Players: ' + playersListLength,
                style: TextStyle(
                    decoration: TextDecoration.none,
                    fontFamily: 'Kefa',
                    fontSize: 15,
                    color: Colors.white),
              ),
              //container for textfields user name and password
              Container(
                height: 50,
                width: 300,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.white),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _name,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "User name",
                          hintStyle:
                              TextStyle(fontFamily: 'Kefa', fontSize: 16.0),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20)),
                    ),
                  ],
                ),
              ),

              //container for raised button
              Container(
                width: 150,
                height: 70,
                padding: EdgeInsets.only(top: 20),
                child: Button(text: 'PLAY', onPressed: onPressed),
              ),
              // SizedBox(
              //   height: 20,
              //   width: 10,
              // ),
              Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  color: Color.fromARGB(0, 255, 255, 255),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 50,
                      width: 200,
                      child: GestureDetector(
                        onTap: (
                            //todo ad new page.......
                            ) {},
                        child: Text(
                          'HOW TO PLAY',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Kefa',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 223, 140, 0),
                          ),
                        ),
                      ),
                      // child: Text(
                      //   textAlign: TextAlign.center,
                      //   decoration: InputDecoration(
                      //     border: InputBorder.none,
                      //     hintText: "HOW TO PLAY",
                      //     hintStyle: TextStyle(
                      //         fontFamily: 'Kefa',
                      //         fontSize: 16.0,
                      //         fontWeight: FontWeight.bold,
                      //         color: Color.fromARGB(255, 223, 140, 0)),
                      //     // contentPadding: EdgeInsets.symmetric(horizontal: (1))
                      //   ),
                      // ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
