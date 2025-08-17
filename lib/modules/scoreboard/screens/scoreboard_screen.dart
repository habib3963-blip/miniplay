import 'package:flutter/material.dart';
import '../services/scoreboard_service.dart';

class ScoreboardScreen extends StatefulWidget {
  const ScoreboardScreen({super.key});
  @override
  State<ScoreboardScreen> createState() => _ScoreboardScreenState();
}

class _ScoreboardScreenState extends State<ScoreboardScreen> {
  final _svc = ScoreboardService();
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = _svc.getScores();
  }

  Future<void> _refresh() async => setState(() => _future = _svc.getScores());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (_, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final scores = snap.data!;
          if (scores.isEmpty) return const Center(child: Text('No scores yet. Go win some games!'));
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              itemCount: scores.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final s = scores[i];
                return ListTile(
                  leading: CircleAvatar(child: Text('${i + 1}')),
                  title: Text(s['player']),
                  trailing: Text('${s['score']}'),
                  subtitle: Text(DateTime.parse(s['ts']).toLocal().toString().substring(0, 16)),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
