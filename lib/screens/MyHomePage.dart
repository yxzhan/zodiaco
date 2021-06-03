import 'package:flutter/material.dart';
import 'GameBoard.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
