import 'dart:math';

class CardsGenerator {
  List<int> allCards = [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9
  ];

  List<List<int>> suffleCards() {
    List<int> res = List.castFrom(allCards);
    res.shuffle();
    int halfSize = (res.length / 2).toInt();
    return [res.sublist(0, halfSize), res.sublist(halfSize)];
  }
}

String randomName() {
  Random random = new Random();
  List<String> colors = [
    'Red',
    'Orange',
    'Yellow',
    'Green',
    'Cyan',
    'Blue',
    'Violet'
  ];
  List<String> names = [
    'Rat',
    'Ox',
    'Tiger',
    'Rabbit',
    'Dragon',
    'Snake',
    'Horse',
    'Goat',
    'Monkey',
    'Rooster',
    'Dog',
    'Pig'
  ];
  return colors[random.nextInt(colors.length - 1)] +
      ' ' +
      names[random.nextInt(names.length - 1)];
}
