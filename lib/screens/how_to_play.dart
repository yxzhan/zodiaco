import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zodiaco/utils/configs.dart';

import 'components/how_to_play_dialog.dart';

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
          child: HowToPlayDialog(),
        ),
      ),
    );
  }


}
