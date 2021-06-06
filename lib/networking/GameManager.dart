import '../utils/CardsGenerator.dart';

class GameManager {
  final List<int> allCardValue = [for (var i = 0; i < 10; i += 1) i];
  List<int> opponentsCard;
  List<int> myCard;

  GameManager() {
    CardsGenerator cardGenerator = new CardsGenerator();
    List<List<int>> cards = cardGenerator.suffleCards();
    opponentsCard = cards[0];
    myCard = cards[1];
  }
}
