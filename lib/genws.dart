import 'package:word_search_safety/word_search_safety.dart';

void main() {
  final List<String> words = ["horses", "compsci", "python"];
  final int i = 10;

  generate_wordsearch(words, i);

}


List<String> generate_wordsearch(List<String> words, int grid_size){
  final WSSettings ws = WSSettings(
      width: grid_size,
      height: grid_size,
      orientations: List.from([
        WSOrientation.horizontal,
        WSOrientation.vertical,
  ]),
  );

  final WSNewPuzzle puzzle = WordSearchSafety().newPuzzle(words, ws);

  return puzzle.puzzle!.expand((element) => element).toList();
}