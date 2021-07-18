import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zodiaco/utils/configs.dart';

class HowToPlay extends StatelessWidget {
  const HowToPlay({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HOW TO PLAY'),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(IMAGE_DIR + 'howtoplay.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Chinese Zodiac', style: _titleStyle()),
              Text(
                'The Chinese zodiac is a classification scheme based on the lunar calendar that assigns an animal and its reputed attributes to each year in a repeating 12-year cycle. In order, the 12 animal signs are Rat, Ox, Tiger, Rabbit, Dragon, Snake, Horse, Goat, Monkey, Rooster, Dog, Pig.',
                style: _textStyle(),
              ),
              Text(
                'We got inspiration from this idea and applied it to our cards.',
                style: _textStyle(),
              ),
              Text(
                'Gameplay',
                style: _titleStyle(),
              ),
              Text(
                'The goal of this game is to reveal all of your opponent’s cards.',
                style: _textStyle(),
              ),
              Text(
                '1. The game is played using 24 numbered cards - 12 blue cards and 12 yellow cards.',
                style: _textStyle(),
              ),
              Text(
                '2. Each player randomly gets 10 cards sorted according to their number and color (A blue card is considered smaller than the yellow one).',
                style: _textStyle(),
              ),
              Text(
                '3. Card ‘A’ (Rat) can be placed in any position.',
                style: _textStyle(),
              ),
              Text(
                '4. Each player takes turns to guess the number of the opponent’s card. If you are right, keep guessing or skip this turn; if you are wrong, turn over one of your cards.',
                style: _textStyle(),
              ),
              Text(
                '5. A player loses the game whose cards are completely revealed.',
                style: _textStyle(),
              ),
            ],
          ),
        ),
      ),
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
