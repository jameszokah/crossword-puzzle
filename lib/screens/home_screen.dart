import 'package:crossword_puzzle/widgets/game.dart';
import 'package:flutter/material.dart';
import 'package:crossword_puzzle/modals/player.dart';
import 'package:crossword_puzzle/screens/game_screen.dart';

class HomeScreen extends StatelessWidget {
  final Player currentPlayer;

  HomeScreen({required this.currentPlayer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crossword Puzzle'),
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/crossword.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Card(
              // elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Current Player:',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      currentPlayer.name!,
                      style: const TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GameScreen(),
                          ),
                        );
                      },
                      child: const Text('Start Game'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
