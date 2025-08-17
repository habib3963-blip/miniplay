import 'dart:math';
import 'package:flutter/material.dart';

class PuzzleGame extends StatefulWidget {
  const PuzzleGame({super.key});

  @override
  State<PuzzleGame> createState() => _PuzzleGameState();
}

class _PuzzleGameState extends State<PuzzleGame> {
  final int gridSize = 4; // 4x4 puzzle
  late List<int> tiles;
  int moves = 0;
  Stopwatch timer = Stopwatch();

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    tiles = List.generate(gridSize * gridSize, (index) => index);
    _shuffleTiles();
    moves = 0;
    timer.reset();
    timer.start();
  }

  void _shuffleTiles() {
    do {
      tiles.shuffle(Random());
    } while (!_isSolvable(tiles));
  }

  bool _isSolvable(List<int> list) {
    int invCount = 0;
    for (int i = 0; i < list.length; i++) {
      for (int j = i + 1; j < list.length; j++) {
        if (list[i] != 0 && list[j] != 0 && list[i] > list[j]) {
          invCount++;
        }
      }
    }
    int emptyRow = gridSize - (list.indexOf(0) ~/ gridSize);
    if (gridSize % 2 == 1) {
      return invCount % 2 == 0;
    } else {
      return (emptyRow % 2 == 0) != (invCount % 2 == 0);
    }
  }

  void _onTileTap(int index) {
    int emptyIndex = tiles.indexOf(0);
    if (_canMove(index, emptyIndex)) {
      setState(() {
        tiles[emptyIndex] = tiles[index];
        tiles[index] = 0;
        moves++;
      });

      if (_isSolved()) {
        timer.stop();
        _showWinDialog();
      }
    }
  }

  bool _canMove(int tileIndex, int emptyIndex) {
    int row1 = tileIndex ~/ gridSize;
    int col1 = tileIndex % gridSize;
    int row2 = emptyIndex ~/ gridSize;
    int col2 = emptyIndex % gridSize;
    return (row1 == row2 && (col1 - col2).abs() == 1) ||
        (col1 == col2 && (row1 - row2).abs() == 1);
  }

  bool _isSolved() {
    for (int i = 0; i < tiles.length - 1; i++) {
      if (tiles[i] != i + 1) return false;
    }
    return true;
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Puzzle Solved!'),
        content: Text('Moves: $moves\nTime: ${timer.elapsed.inSeconds} seconds'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _startNewGame());
            },
            child: const Text('Play Again'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width - 32;
    double tileSize = size / gridSize;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sliding Puzzle'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() => _startNewGame()),
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Text('Moves: $moves', style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text('Time: ${timer.elapsed.inSeconds}s', style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 16),
          SizedBox(
            width: size,
            height: size,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridSize,
              ),
              itemCount: tiles.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _onTileTap(index),
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: tiles[index] == 0 ? Colors.grey[300] : Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: tiles[index] == 0
                          ? const SizedBox.shrink()
                          : Text(
                        '${tiles[index]}',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
