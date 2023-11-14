
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class VictoryPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
           
            Text(
              'You have won!',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ).animate().fadeIn().flip(),
    );
  }
}
