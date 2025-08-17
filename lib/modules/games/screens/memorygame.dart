import 'package:flutter/material.dart';
import 'dart:math';

class MemoryGame extends StatefulWidget {
  const MemoryGame({super.key});

  @override
  State<MemoryGame> createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {
  final int _gridSize = 4;
  late List<String> _cards;
  List<bool> _revealed = [];
  int? _firstIndex;
  bool _waiting = false;
  int _moves = 0;
  int _matches = 0;
  Stopwatch _timer = Stopwatch();

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    List<String> icons = [
      '🍎','🍎','🍌','🍌','🍇','🍇','🍓','🍓',
      '🍍','🍍','🥝','🥝','🍑','🍑','🍉','🍉'
    ];
    icons.shuffle(Random());
    _cards = icons;
    _revealed = List.filled(icons.length, false);
    _firstIndex = null;
    _waiting = false;
    _moves = 0;
    _matches = 0;
    _timer.reset();
    _timer.start();
  }

  void _onCardTap(int index) {
    if (_waiting || _revealed[index]) return;

    setState(() {
      _revealed[index] = true;
    });

    if (_firstIndex == null) {
      _firstIndex = index;
    } else {
      _moves++;
      if (_cards[_firstIndex!] != _cards[index]) {
        _waiting = true;
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            _revealed[_firstIndex!] = false;
            _revealed[index] = false;
            _firstIndex = null;
            _waiting = false;
          });
        });
      } else {
        _matches++;
        _firstIndex = null;

        if (_matches == _cards.length ~/ 2) {
          _timer.stop();
          _showGameOverDialog();
        }
      }
    }
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎉 You Won!'),
        content: Text('Moves: $_moves\nTime: ${_timer.elapsed.inSeconds} seconds'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _initializeGame());
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
    double screenWidth = MediaQuery.of(context).size.width;
    double cardSize = (screenWidth - 80) / 4;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Match'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() => _initializeGame()),
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Text('Moves: $_moves   Matches: $_matches',
              style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text('Time: ${_timer.elapsed.inSeconds}s',
              style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _gridSize,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _cards.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _onCardTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    decoration: BoxDecoration(
                      color: _revealed[index] ? Colors.orange : Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        _revealed[index] ? _cards[index] : '',
                        style: const TextStyle(fontSize: 28),
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
