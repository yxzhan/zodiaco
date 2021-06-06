import '../utils/CardsGenerator.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:web_socket_channel/status.dart' as status;

class GameManager {
  final List<int> allCardValue = [for (var i = 0; i < 10; i += 1) i];
  List<int> opponentsCard;
  List<int> myCard;

  GameManager() {
    CardsGenerator cardGenerator = new CardsGenerator();
    List<List<int>> cards = cardGenerator.suffleCards();
    opponentsCard = cards[0];
    myCard = cards[1];

    // var channel =
    //     WebSocketChannel.connect(Uri.parse('ws://192.168.2.126:23456'));
    // channel.stream.listen((message) {
    //   print(message);
    // });
  }
}
