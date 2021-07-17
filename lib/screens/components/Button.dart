import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final Function onPressed;

  Button({Key key, this.text, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        color: Color.fromARGB(255, 223, 140, 0),
        child: Text(
          text,
          style: TextStyle(
              fontFamily: 'Kefa',
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30),
        ),
        onPressed: onPressed);
  }
}
