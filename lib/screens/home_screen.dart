import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:crossword_puzzle/modals/player.dart';
import 'package:crossword_puzzle/screens/game_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum GameType { easy, hard }

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Player currentPlayer =
      Player(name: 'Player 1', avatar: Avatar(name: 'Player 1', image: ''));

  TextEditingController nameController = TextEditingController();
  late SharedPreferences prefs;
  GameType gameType = GameType.easy;

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  _loadName() async {
    prefs = await SharedPreferences.getInstance();
    String? savedName = prefs.getString('player_name');
    if (savedName != null) {
      setState(() {
        nameController.text = savedName;
        currentPlayer.name = savedName;
      });
    }
  }

  _saveName() async {
    prefs.setString('player_name', nameController.text);
    setState(() {
      currentPlayer.name = nameController.text;
    });
  }

  _showNameInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Your Name:'),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: 'Player Name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _saveName();
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crossword Puzzle'),
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _showNameInputDialog(context);
            },
          ),
        ],
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
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GameScreen(),
                          ),
                        );
                      },
                      child: const Text('Start Game'),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ).animate().fadeIn(duration: Duration(seconds: 1)),
          ),
        ],
      ),
    );
  }
}
