import 'dart:math';

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
