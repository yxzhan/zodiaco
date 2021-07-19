import 'package:flutter/material.dart';

class HowToPlayDialog extends StatelessWidget {
  const HowToPlayDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/loginbg.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: AlertDialog(
        title: const Text(
          'HOW TO PLAY',
          style: TextStyle(
            fontFamily: 'Kefa',
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 223, 140, 0),
          ),
        ),
        content: SingleChildScrollView(
          // child: ListBody(
          //   children: const <Widget>[
          //     Text('This is a demo alert dialog.'),
          //     Text('Would you like to approve of this message?'),
          //   ],
          // ),
          child: gameplayText(),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget gameplayText() {
    return Column(
      children: [
        Text('Chinese Zodiac', style: _titleStyle()),
        SizedBox(height: 10.0),
        Text(
          'The Chinese zodiac is a classification scheme based on the lunar calendar that assigns an animal and its reputed attributes to each year in a repeating 12-year cycle. In order, the 12 animal signs are Rat, Ox, Tiger, Rabbit, Dragon, Snake, Horse, Goat, Monkey, Rooster, Dog, Pig.',
          style: _textStyle(),
        ),
        SizedBox(height: 10.0),
        Text(
          'We got inspiration from this idea and applied it to our cards.',
          style: _textStyle(),
        ),
        SizedBox(height: 10.0),
        Text(
          'Gameplay',
          style: _titleStyle(),
        ),
        SizedBox(height: 10.0),
        Text(
          'The goal of this game is to reveal all of your opponent’s cards.',
          style: _textStyle(),
        ),
        SizedBox(height: 10.0),
        Text(
          '1. The game is played using 24 numbered cards - 12 blue cards and 12 yellow cards.',
          style: _textStyle(),
        ),
        SizedBox(height: 10.0),
        Text(
          '2. Each player randomly gets 10 cards sorted according to their number and color (A blue card is considered smaller than the yellow one).',
          style: _textStyle(),
        ),
        SizedBox(height: 10.0),
        Text(
          '3. Card ‘A’ (Rat) can be placed in any position.',
          style: _textStyle(),
        ),
        SizedBox(height: 10.0),
        Text(
          '4. Each player takes turns to guess the number of the opponent’s card. If you are right, keep guessing or skip this turn; if you are wrong, turn over one of your cards.',
          style: _textStyle(),
        ),
        SizedBox(height: 10.0),
        Text(
          '5. A player loses the game whose cards are completely revealed.',
          style: _textStyle(),
        ),
      ],
    );
  }

  TextStyle _titleStyle() {
    return TextStyle(
      fontFamily: 'Kefa',
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
      color: Color.fromARGB(255, 223, 140, 0),
    );
  }

  TextStyle _textStyle() {
    return TextStyle(
      fontFamily: 'Kefa',
      // fontSize: 16.0,
      // fontWeight: FontWeight.bold,
      color: Color.fromARGB(255, 223, 140, 0),
    );
  }
}
