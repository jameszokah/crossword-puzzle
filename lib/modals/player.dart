class Avatar {
  String name;
  String image;

  Avatar({required this.name, required this.image});
}

class Player {
  String? name;
  int score;
  Avatar avatar;

  Player({required this.name, required this.avatar, this.score = 0});

  void incrementScore() {
    score++;
  }

  @override
  String toString() {
    return 'Player(name: $name, score: $score, avatar: ${avatar.name})';
  }
}
