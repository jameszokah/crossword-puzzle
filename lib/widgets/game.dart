import 'package:flutter/material.dart';

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  List<String> _words = ['hello', 'world', 'flutter'];
  int _score = 0;
  String _selectedWord = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.0,
              ),
              itemCount: 42,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onHorizontalDragUpdate: (d) {
                    setState(() {
                      _selectedWord += 'A';
                      print(d); // Replace with actual letter
                    });
                  },
                  child: Hexagon(),
                );
              },
            ),
          ),
          SizedBox(height: 16),
          Text('Selected word: $_selectedWord'),
          SizedBox(height: 8),
          Text('Words: ${_words.join(', ')}'),
          SizedBox(height: 8),
          Text('Score: $_score'),
        ],
      ),
    );
  }
}

class Hexagon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey[300]!, width: 2),
      ),
      child: ClipOval(
        child: Container(
          color: Colors.blueGrey[100],
          padding: EdgeInsets.all(8),
          child: Center(
            child: Text(
              'A', // Replace with actual letter
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }
}
