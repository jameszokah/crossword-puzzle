import 'dart:async';

import 'package:confetti/confetti.dart';
// import 'package:crossword_puzzle/events/events.dart';
import 'package:crossword_puzzle/modals/modals.dart';
import 'package:crossword_puzzle/utils/constant.dart';
import 'package:crossword_puzzle/utils/utils.dart';
import 'package:crossword_puzzle/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:word_search_safety/word_search_safety.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late ValueNotifier<List<List<String>>>? charList;
  late ValueNotifier<List<CrossWordAnswer>>? answerList;
  late ValueNotifier<CurrentDragObj> currentDragObj;
  late ValueNotifier<List<int>> charsDone;

  late ConfettiController? controllerCenter;

  final player = AudioPlayer();

  List<String> _selectedLetters = [];

  int _level = 1;

  int numBoxPerRow = 8;
  bool _gameOverDialogShown = false;

  int _score = 0;
  late Timer? _timer;
  bool _isPaused = false;
  bool victoryPopup = false;
  bool startNewGame = false;
  bool isGameOver = false;

  int _timeLeft = 180;

  double padding = 5;
  Size sizeBox = Size.zero;

  @override
  void initState() {
    super.initState();
    charList = ValueNotifier<List<List<String>>>([]);
    answerList = ValueNotifier<List<CrossWordAnswer>>([]);

    currentDragObj = ValueNotifier<CurrentDragObj>(
        CurrentDragObj(indexArrayOnTouch: -1, currentTouch: Offset.zero));
    charsDone = ValueNotifier<List<int>>([]);

    // controllers

    controllerCenter = ConfettiController(duration: const Duration(seconds: 2));
    // controllerCenter!.play();

    generateRandomWord(
        charList: charList!,
        numBoxPerRow: numBoxPerRow,
        answerList: answerList!);
    _startTimer();

    player
        .setSource(AssetSource('sounds/background_sound.wav'))
        .then((value) => {});
    player
        .setSource(AssetSource('sounds/correct_word.wav'))
        .then((value) => {});
    player.setSource(AssetSource('sounds/game_over.wav')).then((value) => {});
    player.setSource(AssetSource('sounds/victory.wav')).then((value) => {});

    player.play(AssetSource('sounds/background_sound.wav'));
    player.audioCache.load(
        'sounds/correct_word.wav'); // Replace 'correct_word.mp3' with your actual file name
    player.audioCache.load('sounds/victory.wav');
    player.audioCache.load('sounds/game_over.wav');
  }

  @override
  void dispose() {
    controllerCenter!.dispose();
    super.dispose();
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_timeLeft == 0) {
          timer.cancel();
          // timer
          if (!isGameOver) {
            _endGame();
            setState(() {
              isGameOver = true;
            });
          }
        } else if (!_isPaused) {
          setState(() {
            _timeLeft--;
          });
        }
      },
    );
  }

  void _pauseTimer() {
    // You can add additional logic here if needed
    // For example, stop animations or other time-dependent processes
    print('Game Paused!');
  }

  void _resumeTimer() {
    // Add logic to handle tasks when the game is resumed
    print('Game Resumed');

    // Clear any existing timer before starting a new one
    _clearTimer();

    // Restart the timer
    _startTimer();
  }

  void _clearTimer() {
    // Clear the existing timer
    // This ensures that there's only one active timer at a time
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
  }

  void _endGame() {
    if (!_gameOverDialogShown) {
      setState(() {
        _gameOverDialogShown = true;
      });

      showDialog<void>(
        context: context,
        builder: (context) => errorAlert(context),
      );

      resetTimer();
      resetStrokes(); // Reset the strokes
      resetGame();

      // Check for a win and increment the level
      if (_score > 0 && _score % (3 * 10) == 0) {
        _level++;
        // You can add additional logic here when a new level is reached
      }
      player.play(AssetSource('sounds/game_over.wav'));
    }
    // Play a sound effect for game over
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });

    if (_isPaused) {
      _pauseTimer();
    } else {
      _resumeTimer();
    }
  }

  void resetGame() {
    setState(() {
      _score = 0;
      _timeLeft = 180;
      _isPaused = false;
      _selectedLetters = [];
      _gameOverDialogShown = false; // Reset the flag
      _level = 1;

      generateRandomWord(
          charList: charList!,
          numBoxPerRow: numBoxPerRow,
          answerList: answerList!);
    });
    resetStrokes(); // Reset the strokes
    ; // Reset the level
  }

  void resetStrokes() {
    setState(() {
      answerList!.value.forEach((answer) {
        answer.done = false;
      });
      charsDone.value.clear();
    });
  }

  void _onLetterSelected(String letter) {
    int letterScore = calculateLetterScore(
        letter); // You can implement your custom scoring logic
    setState(() {
      _selectedLetters.add(letter);
      _score += letterScore;
    });

    // Play a sound effect for correct word
    player.play(AssetSource('sounds/correct_word.wav')).then((v) {});
  }

  int calculateLetterScore(String letter) {
    // Implement your custom scoring logic based on the letter
    // For example, you can return different scores for different letters
    // or you can have a scoring table based on letter frequency, etc.
    // This function will be called for each selected letter.
    return 10; // Default score is 10 for this example
  }

  void resetTimer() {
    setState(() {
      _timeLeft = 180; // Set the initial time or any other desired time
    });
    _startTimer(); // Start the timer again
  }

  Widget errorAlert(BuildContext context) {
    return AlertDialog(
      title: const Text('Game Over'),
      content: Text('Your score: $_score'),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              // startNewGame = true;
              _gameOverDialogShown = false;
              isGameOver = false;
            });
            resetGame();

            Navigator.of(context).pop();
          },
          child: const Text('RESTART'),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              // startNewGame = true;
              _gameOverDialogShown = false;
              isGameOver = false;
              _timeLeft = 1;
            });
            _togglePause();

            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    )
        .animate()
        .slideY(begin: -25, end: 0, duration: const Duration(seconds: 1))
        .fadeIn(
            duration: const Duration(seconds: 1),
            delay: const Duration(seconds: 1))
        .shakeX(
            delay: const Duration(seconds: 1),
            duration: const Duration(seconds: 1));
  }

  Widget successAlert(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Congratulations!!!',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        children: [
          VictoryPopup(),
          const SizedBox(height: 10),
          GameConfetti(
            controllerCenter: controllerCenter,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => controllerCenter!.play(),
          style: TextButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          child:
              const Text('Celebrate!!!', style: TextStyle(color: Colors.white)),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          child: const Text('ACCEPT', style: TextStyle(color: Colors.white)),
        ),
      ],
    )
        .animate()
        .slideY(begin: 25, end: 0, duration: const Duration(seconds: 1))
        .fadeIn(
            duration: const Duration(seconds: 1),
            delay: const Duration(seconds: 1))
        .flipH(delay: const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      // backgroundColor: Colors.redAccent[100],
      appBar: AppBar(
        title: const Text('Crossword Puzzle'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            // var exit = false;
            // showDialog<void>(
            //     context: context,
            //     builder: (context) => AlertDialog(
            //           title: const Text('Quit Game'),
            //           content: const Text('Are you sure you want to quit?'),
            //           actions: [
            //             TextButton(
            //               onPressed: () {
            //                 setState(() {
            //                   exit = true;
            //                 });
            //                 Navigator.of(context).pop();
            //               },
            //               child: const Text('OK'),
            //             ),
            //           ],
            //         ));

            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
            onPressed: _togglePause,
          ),
        ],
      ),
      body: Column(
        children: [
          Text(
            'Level $_level',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Time left: $_timeLeft',
            style: TextStyle(
              // fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            key: ValueKey('game_stats'),
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Score: ',
              ),
              const SizedBox(width: 5),
              Text(
                '$_score',
                style: TextStyle(
                  // fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
              height: size.width,
              child: generateCrossWordBox(charList!, _onLetterSelected)),
          // SizedBox
          const SizedBox(height: 10),
          drawAnswerList(_selectedLetters, numBoxPerRow),

          // victoryPopup ? VictoryPopup() : const SizedBox(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          resetGame();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget generateCrossWordBox(ValueNotifier<List<List<String>>> valueNotifier,
      void Function(String letter) onLetterSelected) {
    return Listener(
      onPointerUp: (event) {
        onDragEnd(event);
        // onDragEnd(event, currentDragObj);
      },
      onPointerMove: (event) {
        onDragUpdate(event);

        // onDragUpdate(event, numBoxPerRow, answerList,
        // charsDone, currentDragObj, padding, sizeBox)
      },
      child: LayoutBuilder(builder: (context, constraints) {
        sizeBox = Size(constraints.maxWidth, constraints.maxWidth);
        return ValueListenableBuilder<List<List<String>>>(
          valueListenable: valueNotifier,
          builder: (context, value, child) {
            List<String> letters = value.expand((element) => element).toList();
            return Card(
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: numBoxPerRow * numBoxPerRow,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: numBoxPerRow,
                  childAspectRatio: 1.0,
                ),
                itemBuilder: (context, index) {
                  String char = letters[index];
                  return Listener(
                    onPointerDown: (event) {
                      onDragStart(index);
                      // onDragStart(
                      // event,
                      // index,
                      // numBoxPerRow,
                      // answerList,
                      // currentDragObj,
                      // padding,
                      // sizeBox)
                    },
                    child: ValueListenableBuilder(
                        valueListenable: currentDragObj,
                        builder: (context, CurrentDragObj value, child) {
                          Color? color = Colors.transparent;
                          Color? charColor = Constant.kPrimaryColor;

                          if (value.currentDragLine.contains(index)) {
                            color = Colors.red[
                                800]; // change color when path line is contain index
                            charColor = Constant.kWhiteColor;
                          } else if (charsDone.value.contains(index)) {
                            color = Colors
                                .green; // change color box already path correct
                            charColor = Constant.kWhiteColor;
                            if (_timeLeft == 0) {
                              color = Colors.transparent;
                            }
                          }

                          return CustomPaint(
                            painter: RPSCustomPainter(
                                color: color, colorFill: color),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 10,
                                    offset: const Offset(0.1, 0.3),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  char.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: charColor,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  );
                },
              ),
            );
          },
        );
      }),
    );
  }

  Widget drawAnswerList(List<String> selectedLetters, int numBoxPerRow) {
    return ValueListenableBuilder<List<CrossWordAnswer>>(
      valueListenable: answerList!,
      builder: (context, value, child) {
        int perColTotal = 4;

        final len =
            (value.length ~/ perColTotal) + (value.length % perColTotal) > 0
                ? 1
                : 0;

        return Container(
          // padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 8),
          child: Expanded(
            child: ListView.builder(
                itemCount: len,
                itemBuilder: (context, index) {
                  return wordBuilder(perColTotal, value, index);
                }),
          ),
        );
      },
    );
  }

  Widget wordBuilder(int perColTotal, List<CrossWordAnswer> value, int index) {
    int maxColumn = (index + 1) * perColTotal;

    return Wrap(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: wordListView(maxColumn, value, perColTotal, index).toList(),
    );
  }

  List<Widget> wordListView(
      int maxColumn, List<CrossWordAnswer> value, int perColTotal, int index) {
    int len = maxColumn > value.length ? maxColumn - value.length : perColTotal;
    return List<Widget>.generate(len, (int i) {
      final int idx = index * perColTotal + i;
      final word = value[idx].wsloaction!.word;

      // if (value[idx].done) {
      //   _score += 10;
      // }
      return AnimatedContainer(
        duration: const Duration(seconds: 1),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        margin: const EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Constant.kPrimaryColorAccent,
            width: 2,
          ),
          color: value[idx].done ? Colors.green : Constant.kWhiteColor,
        ),
        child: Center(
          child: Text(
            word,
            style: TextStyle(
              // fontSize: 18,
              color: value[idx].done
                  ? Constant.kWhiteColor
                  : Constant.kPrimaryColor,
            ),
          ),
        ),
      );
    });
  }

  void onDragEnd(PointerUpEvent? event) {
    print("PointerUpEvent");
    // check if drag line object got value or not.. if no no need to clear
    if (currentDragObj.value.currentDragLine == null) return;

    currentDragObj.value.currentDragLine.clear();
    currentDragObj.notifyListeners();
  }

  void onDragUpdate(PointerMoveEvent event) {
    // generate ondragLine so we know to highlight path later & clear if condition dont meet .. :D
    generateLineOnDrag(event);

    // get index on drag

    int indexFound = answerList!.value.indexWhere((answer) {
      return answer.answerLines!.join("-") ==
          currentDragObj.value.currentDragLine.join("-");
    });

    print(currentDragObj.value.currentDragLine.join("-"));
    if (indexFound >= 0) {
      answerList!.value[indexFound].done = true;
      // save answerList which complete
      charsDone.value.addAll(answerList!.value[indexFound].answerLines!);
      charsDone.notifyListeners();
      answerList!.notifyListeners();
      onDragEnd(null);

      // Check for win condition after completing a word
      if (checkForWin()) {
        controllerCenter!.play();
        showDialog<void>(
          context: context,
          builder: (context) {
            resetTimer();
            resetStrokes(); // Reset the strokes
            // Play a sound effect for victory
            player.play(AssetSource('sounds/victory.wav'));
            return successAlert(context);
          },
        );
      }
    }
  }

  int calculateIndexBasePosLocal(Offset localPosition) {
    // get size max per box
    double maxSizeBox =
        ((sizeBox.width - (numBoxPerRow - 1) * padding) / numBoxPerRow);

    if (localPosition.dy > sizeBox.width || localPosition.dx > sizeBox.width)
      return -1;

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

  void generateLineOnDrag(PointerMoveEvent event) {
    // if current drag line is null, dlcare new list for we can save value
    if (currentDragObj.value.currentDragLine == null)
      currentDragObj.value.currentDragLine ??= [];

    // we need calculate index array base local position on drag
    int indexBase = calculateIndexBasePosLocal(event.localPosition);

    if (indexBase >= 0) {
      // check drag line already pass 2 box
      if (currentDragObj.value.currentDragLine.length >= 2) {
        // check drag line is straight line
        WSOrientation? wsOrientation;

        if (currentDragObj.value.currentDragLine[0]! % numBoxPerRow ==
            currentDragObj.value.currentDragLine[1]! % numBoxPerRow)
          wsOrientation =
              WSOrientation.vertical; // this should vertical.. my mistake.. :)
        else if (currentDragObj.value.currentDragLine[0]! ~/ numBoxPerRow ==
            currentDragObj.value.currentDragLine[1]! ~/ numBoxPerRow)
          wsOrientation = WSOrientation.horizontal;

        if (wsOrientation! == WSOrientation.horizontal) {
          if (indexBase ~/ numBoxPerRow !=
              currentDragObj.value.currentDragLine[1]! ~/ numBoxPerRow)
            onDragEnd(null);
        } else if (wsOrientation! == WSOrientation.vertical) {
          if (indexBase % numBoxPerRow !=
              currentDragObj.value.currentDragLine[1]! % numBoxPerRow)
            onDragEnd(null);
        } else
          onDragEnd(null);
      }

      if (!currentDragObj.value.currentDragLine.contains(indexBase))
        currentDragObj.value.currentDragLine.add(indexBase);
      else if (currentDragObj.value.currentDragLine.length >=
          2) if (currentDragObj.value.currentDragLine[
              currentDragObj.value.currentDragLine.length - 2] ==
          indexBase) onDragEnd(null);
    }
    currentDragObj.notifyListeners();
  }

  void onDragStart(int indexArray) {
    try {
      List<CrossWordAnswer> indexSelecteds = answerList!.value
          .where((answer) => answer.indexArray == indexArray)
          .toList();

      if (indexSelecteds.length == 0) return;
      // nice triggered
      currentDragObj.value.indexArrayOnTouch = indexArray;
      currentDragObj.notifyListeners();

      // this line to call _onLetterSelected with the selected letter
      _onLetterSelected(indexSelecteds[0].wsloaction!.word[0]);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

// Add a method to check for the win condition
  bool checkForWin() {
    return answerList!.value.every((answer) {
      return answer.done;
    });
  }
}
