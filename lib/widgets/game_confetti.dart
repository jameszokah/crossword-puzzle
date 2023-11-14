import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:crossword_puzzle/widgets/widgets.dart';

class GameConfetti extends StatefulWidget {
  final ConfettiController? controllerCenter;

  const GameConfetti({super.key, required this.controllerCenter});

  @override
  _GameConfettiState createState() => _GameConfettiState();
}

class _GameConfettiState extends State<GameConfetti> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: ConfettiWidget(
            confettiController: widget.controllerCenter!,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            maxBlastForce: 5,
            minBlastForce: 2,
            emissionFrequency: 0.05,
            numberOfParticles: 50,
            gravity: 0.05,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple,
            ],
          ),
        ),
        
        // Positioned(
        //   bottom: 20,
        //   right: 20,
        //   child: ElevatedButton(
        //     onPressed: () {
        //       widget.controllerCenter!.play();
        //     },
        //     child: const Text('Shoot Confetti'),
        //   ),
        // ),



        



      ],
    );
  }
}
