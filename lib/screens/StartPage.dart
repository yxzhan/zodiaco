import 'package:flutter/material.dart';
import 'GameBoard.dart';

class StartPage extends StatefulWidget {
  StartPage({Key key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  String playName = '';
  void _startGame() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GameBoard(playerName: playName)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zodiaco'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Zodiaco',
              ),
              TextField(
                onChanged: (String val) async {
                  playName = val;
                },
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your name',
                ),
              ),
              ElevatedButton(
                onPressed: _startGame,
                child: Text('Start'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
