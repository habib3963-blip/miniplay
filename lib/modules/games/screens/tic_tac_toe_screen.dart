import 'package:flutter/material.dart';
import '../../scoreboard/services/scoreboard_service.dart';

class TicTacToeScreen extends StatefulWidget {
  const TicTacToeScreen({super.key});
  @override
  State<TicTacToeScreen> createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> with SingleTickerProviderStateMixin {
  List<String> b = List.filled(9, '');
  bool xTurn = true;
  String winner = '';
  late AnimationController _ctrl;
  final _svc = ScoreboardService();

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void tap(int i) {
    if (b[i] != '' || winner.isNotEmpty) return;
    setState(() => b[i] = xTurn ? 'X' : 'O');
    xTurn = !xTurn;
    _ctrl.forward(from: 0);
    final w = _checkWinner();
    if (w.isNotEmpty) {
      setState(() => winner = w);
      // Add score: winner gets +1
      _svc.addScore(player: w == 'X' ? 'Player X' : 'Player O', score: 1);
      _showEndDialog('$w wins!');
    } else if (!b.contains('')) {
      _showEndDialog('Draw!');
    }
  }

  Future<void> _showEndDialog(String text) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Game Over'),
        content: Text(text),
        actions: [
          TextButton(onPressed: () { Navigator.pop(context); _reset(); }, child: const Text('Play Again')),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }

  void _reset() => setState(() { b = List.filled(9, ''); xTurn = true; winner = ''; });

  String _checkWinner() {
    const lines = [
      [0,1,2],[3,4,5],[6,7,8],
      [0,3,6],[1,4,7],[2,5,8],
      [0,4,8],[2,4,6],
    ];
    for (final l in lines) {
      if (b[l[0]] != '' && b[l[0]] == b[l[1]] && b[l[1]] == b[l[2]]) {
        return b[l[0]];
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tic Tac Toe')),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Text('Turn: ${xTurn ? 'X' : 'O'}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 8, crossAxisSpacing: 8),
              itemCount: 9,
              itemBuilder: (_, i) => _Cell(value: b[i], onTap: () => tap(i), ctrl: _ctrl),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ElevatedButton.icon(
              onPressed: _reset,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  final String value;
  final VoidCallback onTap;
  final AnimationController ctrl;
  const _Cell({required this.value, required this.onTap, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.9, end: 1).animate(CurvedAnimation(parent: ctrl, curve: Curves.easeOutBack)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(colors: [Color(0xFF4A86E8), Color(0xFFE67C73)]),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 6))],
          ),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
