import 'package:crossword_puzzle/modals/player.dart';
import 'package:crossword_puzzle/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:crossword_puzzle/utils/constant.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cross Word Puzzle',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.red, secondary: Constant.kPrimaryColorAccent),
        fontFamily: GoogleFonts.pressStart2p().fontFamily,
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}
