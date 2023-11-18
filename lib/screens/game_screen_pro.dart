import 'package:confetti/confetti.dart';
import 'package:crossword_puzzle/modals/modals.dart';
import 'package:crossword_puzzle/utils/utils.dart';
import 'package:crossword_puzzle/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:crossword/components/line_decoration.dart';
import 'package:crossword/crossword.dart';
import 'dart:math';

class GameScreenPro extends StatefulWidget {
  const GameScreenPro({super.key});

  @override
  State<GameScreenPro> createState() => _GameScreenProState();
}

class _GameScreenProState extends State<GameScreenPro> {
  late ValueNotifier<List<List<String>>>? charList;
  late ValueNotifier<List<CrossWordAnswer>>? answerList;
  late ValueNotifier<CurrentDragObj> currentDragObj;
  late ValueNotifier<List<int>> charsDone;

  late ConfettiController? controllerCenter;

  int numBoxPerRow = 7;
  Color color = Colors.transparent;

  List<List<String>> letters = [];
  List<Color> lineColors = [];

  List<int> letterGrid = [11, 14];

  List<List<String>> generateRandomLetters() {
    final random = Random();
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    List<List<String>> array = List.generate(
        letterGrid.first,
        (_) => List.generate(
            letterGrid.last, (_) => letters[random.nextInt(letters.length)]));

    return array;
  }

  Color generateRandomColor() {
    Random random = Random();

    int r = random.nextInt(200) - 128; // Red component between 128 and 255
    int g = random.nextInt(200) - 128; // Green component between 128 and 255
    int b = random.nextInt(200) - 128; // Blue component between 128 and 255

    return Color.fromARGB(255, r, g, b);
  }

  List<String> generateWords() {
    // Replace this list with your own list of words
    List<String> words = ['apple', 'banana', 'orange', 'grape', 'kiwi'];

    // Shuffle the list to make it more random
    words.shuffle();

    return words;
  }

  List<List<String>> generateCrosswordGrid() {
    List<String> words = generateWords();

    // Split each word into individual characters
    List<List<String>> crosswordGrid = [];
    for (String word in words) {
      List<String> characters = word.split('');
      crosswordGrid.add(characters);
    }

    return crosswordGrid;
  }

  @override
  void initState() {
    // TODO: implement initState
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
    lineColors = List.generate(100, (index) => generateRandomColor()).toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(title: Text('Crossword Puzzle')),
        backgroundColor: Colors.white54,
        body: SingleChildScrollView(
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: size.width,
                // padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(20),
                    // border: Border.all(color: Colors.red[800]!, width: 2)
                    ),
                child: ValueListenableBuilder(
                    valueListenable: charList!,
                    builder: (context, value, child) {
                      print(value);
                      return Crossword(
                          letters: value,
                          spacing: const Offset(30, 30),
                          onLineDrawn: (List<String> words) {
                            print(words);
                            var answers = answerList!.value;

                            for (var i = 0; i <= answers.length; i++) {
                              print(answers.contains(words.last));
                              print(answers[i].wsloaction!.word);
                              if (answers.contains(words.last)) {
                                setState(() {
                                  color = Colors.red;
                                });
                              } else {
                                setState(() {
                                  color = Colors.blue;
                                });
                              }
                              if (answers[i].wsloaction!.word == words[i]) {
                                print(true);
                              }
                            }
                            // print(generateCrosswordGrid());
                          },
                          textStyle: const TextStyle(
                              color: Colors.white, fontSize: 20),
                          lineDecoration: LineDecoration(
                              lineColors: lineColors, strokeWidth: 20),
                          hints: answerList!.value
                              .map((e) => e.wsloaction!.word)
                              .toList());
                    }),
              ),
              Container(
                height: size.width,
                child: ListView(
                  children: answerList!.value.map((e) {
                    return Container(
                        color: color, child: Text(e.wsloaction!.word));
                  }).toList(),
                ),
              ),
            ],
          ),
        ));
  }
}
