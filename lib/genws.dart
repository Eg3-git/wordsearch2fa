import 'package:word_search_safety/word_search_safety.dart';

void main() {
  final List<String> words = ["horses", "compsci", "python"];
  const int i = 10;

  generateWordsearch(words, i);

}


List<String> generateWordsearch(List<String> words, int gridSize){
  final WSSettings ws = WSSettings(
      width: gridSize,
      height: gridSize,
      orientations: List.from([
        WSOrientation.horizontal,
        WSOrientation.vertical,
  ]),
  );

  final WSNewPuzzle puzzle = WordSearchSafety().newPuzzle(words, ws);

  return puzzle.puzzle!.expand((element) => element).toList();
}
