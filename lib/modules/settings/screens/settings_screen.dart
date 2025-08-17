import 'package:flutter/material.dart';
import '../../scoreboard/services/scoreboard_service.dart';
import '../models/settings_model.dart';

class SettingsScreen extends StatelessWidget {
  final SettingsModel settings;
  const SettingsScreen({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    final svc = ScoreboardService();
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: SwitchListTile(
              title: const Text('Dark Mode'),
              value: settings.darkMode,
              onChanged: (v) => settings.setDarkMode(v),
              secondary: const Icon(Icons.nightlight_round),
            ),
          ),
          Card(
            child: SwitchListTile(
              title: const Text('Sound Effects'),
              value: settings.soundOn,
              onChanged: (v) => settings.setSoundOn(v),
              secondary: const Icon(Icons.volume_up),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.delete_forever),
              title: const Text('Reset Leaderboard'),
              subtitle: const Text('Clear all saved scores'),
              onTap: () async {
                await svc.reset();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Leaderboard reset')));
                }
              },
            ),
          ),
          const SizedBox(height: 12),
          const Text('About', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          const Text('MiniPlays — Tiny games. Big fun.'),
        ],
      ),
    );
  }
}
