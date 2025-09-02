import 'dart:math';
import 'package:flutter/material.dart';

// 100+ simple words
const WORDS = [
  'apple', 'angel', 'alien', 'amigo', 'argue', 'angle', 'baker', 'beach', 'bison', 'brief', 'brain', 'brave', 'brown', 'chair', 'cloud', 'comic', 'craft', 'crazy', 'dream', 'daisy', 'demon', 'dance', 'drive', 'dwarf', 'earth', 'eagle', 'enemy', 'enjoy', 'elbow', 'faith', 'fable', 'fence', 'flame', 'friend', 'giant', 'globe', 'ghost', 'grape', 'green', 'guess', 'happy', 'heart', 'honey', 'hotel', 'islet', 'index', 'ivory', 'jolly', 'jewel', 'jumpy', 'joker', 'judge', 'kebab', 'kneel', 'kitty', 'knife', 'knock', 'laser', 'lunar', 'lucky', 'layer', 'lemon', 'magic', 'mango', 'mouse', 'music', 'medal', 'naval', 'ninja', 'night', 'noble', 'nurse', 'ocean', 'olive', 'owner', 'opera', 'panda', 'pearl', 'pixel', 'power', 'quake', 'queen', 'quest', 'quiet', 'racer', 'raven', 'robot', 'rider', 'river', 'rusty', 'radio', 'salad', 'saint', 'shock', 'shark', 'smile', 'sugar', 'tiger', 'tasty', 'thumb', 'topic', 'uncle', 'urban', 'unity', 'valve', 'vivid', 'vodka', 'voter', 'witch', 'wafer', 'wheel', 'waste', 'wisp', 'xenon', 'yacht', 'yodel', 'young', 'zebra', 'zesty', 'zonal', 'flash', 'swift', 'happy', 'grape', 'style', 'beard', 'brisk', 'slide', 'hello', 'shiny', 'storm', 'glory'
];

const HANGMAN_PICS = [
  '''
  +---+
  |   |
      |
      |
      |
      |
 ======''',
  '''
  +---+
  |   |
  O   |
      |
      |
      |
 ======''',
  '''
  +---+
  |   |
  O   |
  |   |
      |
      |
 ======''',
  '''
  +---+
  |   |
  O   |
 /|   |
      |
      |
 ======''',
  '''
  +---+
  |   |
  O   |
 /|\\  |
      |
      |
 ======''',
  '''
  +---+
  |   |
  O   |
 /|\\  |
 /    |
      |
 ======''',
  '''
  +---+
  |   |
  O   |
 /|\\  |
 / \\  |
      |
 ======''',
  '''
  +---+
  |   |
 [O]  |
 /|\\  |
 / \\  |
      |
====RIP====''',
];

void main() {
  runApp(const HangmanApp());
}

class HangmanApp extends StatelessWidget {
  const HangmanApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hangman Game',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.transparent,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          primary: Colors.deepPurple[700],
          secondary: Colors.amberAccent,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF4B006E),
          foregroundColor: Colors.amberAccent,
        ),
      ),
      home: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4B006E), Color(0xFF20232A), Color(0xFF1A1F2B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: HangmanGame(),
      ),
    );
  }
}
class HangmanGame extends StatefulWidget {
  @override
  State<HangmanGame> createState() => _HangmanGameState();
}

class _HangmanGameState extends State<HangmanGame> {
  late String word;
  late Set<String> wordLetters;
  late Set<String> usedLetters;
  int lives = 7;
  String message = '';
  bool finished = false;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    setState(() {
      var rnd = Random();
      word = WORDS[rnd.nextInt(WORDS.length)].toUpperCase();
      wordLetters = word.split('').toSet();
      usedLetters = {};
      lives = 7;
      message = '';
      finished = false;
    });
  }

  void _guessLetter(String letter) {
    if (finished || usedLetters.contains(letter)) return;

    setState(() {
      usedLetters.add(letter);
      if (wordLetters.contains(letter)) {
        wordLetters.remove(letter);
        message = '';
        if (wordLetters.isEmpty) {
          finished = true;
          message = 'XD)) Victory! You guessed: $word';
        }
      } else {
        lives--;
        message = 'Incorrect guess!';
        if (lives < 1) {
          finished = true;
          message = 'X~X( Game Over! The word was: $word';
        }
      }
    });
  }

  Widget _buildAsciiArt() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        HANGMAN_PICS[7 - lives].trimRight(),
        style: const TextStyle(fontFamily: 'Courier', fontSize: 18, color: Color(0xFFF5F5F5)),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _buildWordDisplay() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: word.split('').map((c) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 18),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.deepPurple[900]?.withOpacity(0.7),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.purpleAccent.withOpacity(0.6),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
          border: Border(
            bottom: BorderSide(
              color: Colors.amberAccent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          usedLetters.contains(c) || finished ? c : '_',
          style: const TextStyle(
            fontSize: 32,
            letterSpacing: 3,
            fontWeight: FontWeight.bold,
            color: Color(0xFF00FFF7), // Neon cyan
            shadows: [
              Shadow(
                color: Colors.purpleAccent,
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
      );
    }).toList(),
  );
}


  
Widget _buildKeyboard() {
  List<Widget> keys = [];
  for (int i = 0; i < 26; i++) {
    String letter = String.fromCharCode('A'.codeUnitAt(0) + i);
    keys.add(
      Padding(
        padding: const EdgeInsets.all(2.0),
        child: ElevatedButton(
          onPressed: usedLetters.contains(letter) || finished
              ? null
              : () => _guessLetter(letter),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(40, 40),
            backgroundColor: usedLetters.contains(letter)
                ? Colors.grey[900]
                : Colors.deepPurple[700],
            foregroundColor: usedLetters.contains(letter)
                ? Colors.redAccent
                : Colors.amberAccent,
            shadowColor: Colors.purpleAccent,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: usedLetters.contains(letter)
                    ? Colors.redAccent
                    : Colors.amberAccent,
                width: 2,
              ),
            ),
            padding: EdgeInsets.zero,
          ),
          child: Text(
            letter,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xFF00FFF7), // Neon cyan
              shadows: [
                Shadow(
                  color: Colors.purpleAccent,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  return Wrap(
    alignment: WrapAlignment.center,
    children: keys,
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("+---+|0  Hangman Challenge"),
        backgroundColor: Colors.purple[800],
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            _buildAsciiArt(),
            _buildWordDisplay(),
            _buildKeyboard(),
            const SizedBox(height: 10),
            Text(
              'Lives: $lives',
              style: TextStyle(
                fontSize: 18,
                color:
                    lives > 2 ? Colors.greenAccent : lives > 1 ? Colors.yellow : Colors.redAccent,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.teal),
            ),
            if (finished)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton.icon(
                  onPressed: _startGame,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Play Again"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

