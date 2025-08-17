import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const SnakeGameApp());
}

class SnakeGameApp extends StatelessWidget {
  const SnakeGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SnakeGame(),
    );
  }
}

class SnakeGame extends StatefulWidget {
  const SnakeGame({super.key});

  @override
  State<SnakeGame> createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  final int squaresPerRow = 20;
  final int squaresPerColumn = 30;
  final int speed = 200; // milliseconds

  List<int> snake = [45, 65, 85];
  String direction = 'down';
  int food = Random().nextInt(600);
  Timer? timer;
  int score = 0;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    timer = Timer.periodic(Duration(milliseconds: speed), (Timer timer) {
      setState(() {
        moveSnake();
      });
    });
  }

  void moveSnake() {
    int newHead = snake.last;

    switch (direction) {
      case 'up':
        newHead -= squaresPerRow;
        break;
      case 'down':
        newHead += squaresPerRow;
        break;
      case 'left':
        newHead -= 1;
        break;
      case 'right':
        newHead += 1;
        break;
    }

    if (checkCollision(newHead)) {
      timer?.cancel();
      showGameOver();
      return;
    }

    snake.add(newHead);

    if (newHead == food) {
      score++;
      spawnFood();
    } else {
      snake.removeAt(0);
    }
  }

  bool checkCollision(int newHead) {
    return (newHead < 0 ||
        newHead >= squaresPerRow * squaresPerColumn ||
        snake.contains(newHead) ||
        (direction == 'left' && newHead % squaresPerRow == squaresPerRow - 1) ||
        (direction == 'right' && newHead % squaresPerRow == 0));
  }

  void spawnFood() {
    food = Random().nextInt(squaresPerRow * squaresPerColumn);
  }

  void showGameOver() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Game Over"),
          content: Text("Your score: $score"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                restartGame();
              },
              child: const Text("Restart"),
            ),
          ],
        );
      },
    );
  }

  void restartGame() {
    setState(() {
      snake = [45, 65, 85];
      direction = 'down';
      score = 0;
      spawnFood();
      startGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: squaresPerRow,
              ),
              itemCount: squaresPerRow * squaresPerColumn,
              itemBuilder: (context, index) {
                if (snake.contains(index)) {
                  return Container(color: Colors.green);
                } else if (index == food) {
                  return Container(color: Colors.red);
                } else {
                  return Container(color: Colors.grey[900]);
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "Score: $score",
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: () => setState(() => direction = 'left'), child: const Icon(Icons.arrow_left)),
              ElevatedButton(onPressed: () => setState(() => direction = 'up'), child: const Icon(Icons.arrow_upward)),
              ElevatedButton(onPressed: () => setState(() => direction = 'down'), child: const Icon(Icons.arrow_downward)),
              ElevatedButton(onPressed: () => setState(() => direction = 'right'), child: const Icon(Icons.arrow_right)),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
