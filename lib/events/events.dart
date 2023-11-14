import 'package:crossword_puzzle/modals/modals.dart';
import 'package:crossword_puzzle/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:word_search_safety/word_search_safety.dart';

onDragEnd(
  PointerUpEvent? event,
  ValueNotifier<CurrentDragObj>? currentDragObj,
) {
  debugPrint('onDragEnd');

  // check if drag line object got value or not.. if no no need to clear
  if (currentDragObj?.value.currentDragLine == null) return;

  currentDragObj?.value.currentDragLine.clear();
  currentDragObj?.notifyListeners();
}

onDragUpdate(
    PointerMoveEvent event,
    int numBoxPerRow,
    ValueNotifier<List<CrossWordAnswer>>? answerList,
    ValueNotifier<List<int>> charsDone,
    ValueNotifier<CurrentDragObj> currentDragObj,
    double padding,
    Size sizeBox) {
  debugPrint('onDragUpdate');

  // generate ondragLine so we know to highlight path later & clear if condition dont meet .. :D
  generateLineOnDrag(event, numBoxPerRow, currentDragObj, padding, sizeBox,
      answerList, charsDone);

  // get index on drag

  int indexFound = answerList!.value.indexWhere((answer) {
    return answer.answerLines!.join("-") ==
        currentDragObj.value.currentDragLine.join("-");
  });

  debugPrint(currentDragObj.value.currentDragLine.join("-"));
  if (indexFound >= 0) {
    answerList!.value[indexFound].done = true;
    // save answerList which complete
    charsDone.value.addAll(answerList!.value[indexFound].answerLines!);
    charsDone.notifyListeners();
    answerList!.notifyListeners();
    onDragEnd(null, currentDragObj);
  }
}

int calculateIndexBasePosLocal(
    Offset localPosition, int numBoxPerRow, double padding, Size sizeBox) {
  // get size max per box
  double maxSizeBox =
      ((sizeBox.width - (numBoxPerRow - 1) * padding) / numBoxPerRow);

  if (localPosition.dy > sizeBox.width || localPosition.dx > sizeBox.width) {
    return -1;
  }

  int x = 0, y = 0;
  double yAxis = 0, xAxis = 0;
  double yAxisStart = 0, xAxisStart = 0;

  for (var i = 0; i < numBoxPerRow; i++) {
    xAxisStart = xAxis;
    xAxis += maxSizeBox +
        (i == 0 || i == (numBoxPerRow - 1) ? padding / 2 : padding);

    if (xAxisStart < localPosition.dx && xAxis > localPosition.dx) {
      x = i;
      break;
    }
  }

  for (var i = 0; i < numBoxPerRow; i++) {
    yAxisStart = yAxis;
    yAxis += maxSizeBox +
        (i == 0 || i == (numBoxPerRow - 1) ? padding / 2 : padding);

    if (yAxisStart < localPosition.dy && yAxis > localPosition.dy) {
      y = i;
      break;
    }
  }

  return y * numBoxPerRow + x;
}

onDragStart(
    PointerDownEvent event,
    int indexArray,
    int numBoxPerRow,
    ValueNotifier<List<CrossWordAnswer>>? answerList,
    ValueNotifier<CurrentDragObj> currentDragObj,
    double padding,
    Size sizeBox) {
  debugPrint('onDragStart');

  try {
    List<CrossWordAnswer> indexSelecteds = answerList!.value
        .where((answer) => answer.indexArray == indexArray)
        .toList();

    // check indexSelecteds got any match , if 0 no proceed!
    if (indexSelecteds.isEmpty) return;
    // nice triggered
    currentDragObj.value.indexArrayOnTouch = indexArray;
    currentDragObj.notifyListeners();
  } catch (e) {
    debugPrint(e.toString());
  }
}

void generateLineOnDrag(
    PointerMoveEvent event,
    int numBoxPerRow,
    ValueNotifier<CurrentDragObj> currentDragObj,
    double padding,
    Size sizeBox,
    ValueNotifier<List<CrossWordAnswer>>? answerList,
    ValueNotifier<List<int>> charsDone) {
  // if current drag line is null, dlcare new list for we can save value
  currentDragObj.value.currentDragLine ??= [];

  // we need calculate index array base local position on drag
  int indexBase = calculateIndexBasePosLocal(
      event.localPosition, numBoxPerRow, padding, sizeBox);

  if (indexBase >= 0) {
    // check drag line already pass 2 box
    if (currentDragObj.value.currentDragLine.length >= 2) {
      // check drag line is straight line
      WSOrientation? wsOrientation;

      if (currentDragObj.value.currentDragLine[0]! % numBoxPerRow ==
          currentDragObj.value.currentDragLine[1]! % numBoxPerRow) {
        wsOrientation = WSOrientation.vertical; // vertical line , same column
      } else if (currentDragObj.value.currentDragLine[0]! ~/ numBoxPerRow ==
          currentDragObj.value.currentDragLine[1]! ~/ numBoxPerRow) {
        wsOrientation = WSOrientation.horizontal; // horizontal line , same row
      }

      if (wsOrientation == WSOrientation.horizontal) {
        if (indexBase ~/ numBoxPerRow !=
            currentDragObj.value.currentDragLine[1]! ~/ numBoxPerRow) {
          onDragEnd(null, currentDragObj);
        }
        if (indexBase % numBoxPerRow !=
            currentDragObj.value.currentDragLine[1]! % numBoxPerRow) {
          onDragEnd(null, currentDragObj);
        }
      } else {
        onDragEnd(null, currentDragObj);
      }
    }

    if (!currentDragObj.value.currentDragLine.contains(indexBase)) {
      currentDragObj.value.currentDragLine.add(indexBase);
    } else if (currentDragObj.value.currentDragLine.length >= 2) {
      if (currentDragObj.value.currentDragLine[
              currentDragObj.value.currentDragLine.length - 2] ==
          indexBase) {
        onDragEnd(null, currentDragObj);
      }
    }
  }

  currentDragObj.notifyListeners();
}
