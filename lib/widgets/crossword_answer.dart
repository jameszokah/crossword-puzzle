import 'package:word_search_safety/word_search_safety.dart';

class CrossWordAnswer {
  bool done = false;
  int? indexArray;
  WSLocation? wsloaction;
  List<int>? answerLines;

  CrossWordAnswer({required this.wsloaction, int? numPerRow}) {
    indexArray = wsloaction!.y * numPerRow! + wsloaction!.x;

    answerLines = [];
    getAnswerLines(numPerRow: numPerRow!);
  }

  void getAnswerLines({required int? numPerRow}) {
    // add all index of the word to the answerLines
    answerLines!.addAll(List<int>.generate(wsloaction!.overlap,
        (index) => generateIndexBaseOnAxis(wsloaction!, index, numPerRow!)));
  }

  //  calculate index base on x and y axis
  int generateIndexBaseOnAxis(
      WSLocation? wsloaction, int index, int numPerRow) {
    int x = wsloaction!.x;
    int y = wsloaction.y;

    switch (wsloaction.orientation) {
      case WSOrientation.horizontal:
        x = wsloaction.x + index;
        break;
      case WSOrientation.horizontalBack:
        x = wsloaction.x - index;
        break;
      case WSOrientation.vertical:
        y = wsloaction.y + index;
        break;
      case WSOrientation.verticalUp:
        y = wsloaction.y - index;
        break;
      case WSOrientation.diagonal:
        x = wsloaction.x + index;
        break;
      case WSOrientation.diagonalUp:
        x = wsloaction.x + index;
        break;
      case WSOrientation.diagonalBack:
        x = wsloaction.x - index;
        break;
      case WSOrientation.diagonalUpBack:
        x = wsloaction.x - index;
        break;
    }
    return x + y * numPerRow;
  }
}
