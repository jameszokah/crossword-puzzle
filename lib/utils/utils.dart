import 'package:crossword_puzzle/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:word_generator/word_generator.dart';
import 'package:word_search_safety/word_search_safety.dart';

void generateRandomWord(
    {required ValueNotifier<List<List<String>>> charList,
    words,
    int numBoxPerRow = 7,
    required ValueNotifier<List<CrossWordAnswer>> answerList}) {
  // Create a list of words to be jumbled into a puzzle
  // final List<String> wl = ['hello', 'world', 'foo', 'bar', 'baz', 'dart'];
  final wordGenerator = WordGenerator();
  List<String> wl = wordGenerator.randomNouns(4);
  debugPrint(wl.toString());

  // Create the puzzle sessting object
  final WSSettings ws = WSSettings(
    width: numBoxPerRow,
    height: numBoxPerRow,
    orientations: List.from([
      WSOrientation.horizontal,
      WSOrientation.vertical,
      // WSOrientation.diagonal,
      // WSOrientation.diagonalBack,
      WSOrientation.horizontalBack,
      WSOrientation.verticalUp,
      // WSOrientation.diagonalUp,
    ]),
  );

  // Create new instance of the WordSearch class
  final WordSearchSafety wordSearch = WordSearchSafety();

  // Create a new puzzle
  final WSNewPuzzle newPuzzle = wordSearch.newPuzzle(wl, ws);

  /// Check if there are errors generated while creating the puzzle
  if (newPuzzle.errors!.isEmpty) {
    // The puzzle output
    debugPrint('Puzzle 2D List');

    debugPrint(newPuzzle.toString());
    charList.value = newPuzzle.puzzle!;

    // Solve puzzle for given word list
    final WSSolved solved = wordSearch.solvePuzzle(newPuzzle.puzzle!, wl);
    // All found words by solving the puzzle
    debugPrint('Found Words!');
    
    answerList.value = solved.found!
        .map((solve) =>
            CrossWordAnswer(wsloaction: solve, numPerRow: numBoxPerRow))
        .toList();

    solved.found!.forEach((element) {
      debugPrint('word: ${element.word}, orientation: ${element.orientation}');
      debugPrint('x:${element.x}, y:${element.y}');
    });

    // All words that could not be found
    debugPrint('Not found Words!');
    solved.notFound!.forEach((element) {
      debugPrint('word: $element');
    });
  } else {
    // Notify the user of the errors
    newPuzzle.errors!.forEach((error) {
      debugPrint(error);
    });
  }
}
