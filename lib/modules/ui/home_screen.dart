import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../settings/models/settings_model.dart';
import '../navigation/routes.dart';

class HomeScreen extends StatefulWidget {
  final SettingsModel settings;
  const HomeScreen({super.key, required this.settings});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final AnimationController _bgCtrl;
  int _selectedIndex = 0;

  final games = const [
    ('Tic Tac Toe', 'assets/images/tictactoe.png', [Color(0xFF8E2DE2), Color(0xFF4A00E0)]),
    ('Snake', 'assets/images/snake.png', [Color(0xFFF7971E), Color(0xFFFFD200)]),
    ('Memory Match', 'assets/images/memory.png', [Color(0xFF38ef7d), Color(0xFF11998e)]),
    ('Puzzle', 'assets/images/puzzle.png', [Color(0xFFE55D87), Color(0xFF5FC3E4)]),
    ('Trivia', 'assets/images/trivia.png', [Color(0xFFf46b45), Color(0xFFeea849)]),
  ];

  final Set<int> _visible = {};

  @override
  void initState() {
    super.initState();
    _bgCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 12))..repeat();
    Future.microtask(() async {
      for (int i = 0; i < games.length; i++) {
        await Future.delayed(const Duration(milliseconds: 110));
        if (!mounted) return;
        setState(() => _visible.add(i));
      }
    });
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    super.dispose();
  }

  void _logout() => Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);

  void _onNavTap(int i) {
    setState(() => _selectedIndex = i);
    if (i == 1) Navigator.pushNamed(context, AppRoutes.ticTacToe);       // Games -> sample route
    if (i == 2) Navigator.pushNamed(context, AppRoutes.scoreboard);      // Leaderboard
    if (i == 3) Navigator.pushNamed(context, AppRoutes.settings);        // Profile/Settings
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        title: const Text('MiniPlays', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: Stack(children: [
        const _AnimatedGradient(),
        AnimatedBuilder(
          animation: _bgCtrl,
          builder: (_, __) => _FloatingShapes(progress: _bgCtrl.value),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: _HeaderCard(settings: widget.settings),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  itemCount: games.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: .95),
                  itemBuilder: (context, i) {
                    final (title, image, colors) = games[i];
                    final vis = _visible.contains(i);
                    return AnimatedOpacity(
                      duration: const Duration(milliseconds: 420),
                      opacity: vis ? 1 : 0,
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 420),
                        scale: vis ? 1 : .85,
                        curve: Curves.easeOutBack,
                        child: _GameCard(
                          title: title,
                          imagePath: image,
                          gradient: LinearGradient(colors: [colors[0], colors[1]], begin: Alignment.topLeft, end: Alignment.bottomRight),
                          onPlay: () {
                            if (title == 'Tic Tac Toe') {
                              Navigator.pushNamed(context, AppRoutes.ticTacToe);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Launching $title…')));
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ]),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onNavTap,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF4A86E8),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.videogame_asset), label: 'Games'),
            BottomNavigationBarItem(icon: Icon(Icons.leaderboard), label: 'Leaderboard'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final SettingsModel settings;
  const _HeaderCard({required this.settings});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 550),
      curve: Curves.easeOutBack,
      builder: (_, t, child) => Transform.scale(scale: 0.98 + t * 0.02, child: Opacity(opacity: t, child: child)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(colors: [Color(0xFF4A86E8), Color(0xFFE67C73)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(.12), blurRadius: 24, offset: const Offset(0, 12))],
        ),
        child: Row(
          children: [
            const Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Welcome, Player One!', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                SizedBox(height: 6),
                Text('Pick a game and have fun 🎮', style: TextStyle(color: Colors.white70)),
              ]),
            ),
            Switch(
              value: settings.darkMode,
              onChanged: (v) => settings.setDarkMode(v),
              activeColor: Colors.white,
              activeTrackColor: Colors.white24,
            ),
          ],
        ),
      ),
    );
  }
}

class _GameCard extends StatefulWidget {
  final String title, imagePath;
  final VoidCallback onPlay;
  final Gradient gradient;
  const _GameCard({required this.title, required this.imagePath, required this.onPlay, required this.gradient});

  @override
  State<_GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<_GameCard> {
  double _press = 0;
  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => setState(() => _press = .03),
      onPointerUp: (_) => setState(() => _press = 0),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: 1 - _press,
        child: Container(
          decoration: BoxDecoration(
            gradient: widget.gradient,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(.07), blurRadius: 18, offset: const Offset(0, 8))],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Hero(tag: widget.title, child: Image.asset(widget.imagePath, height: 110)),
            const SizedBox(height: 10),
            Text(widget.title, textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.white)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: widget.onPlay,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF4A86E8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
              child: const Text('Play'),
            ),
          ]),
        ),
      ),
    );
  }
}

class _AnimatedGradient extends StatelessWidget {
  const _AnimatedGradient();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFFF7F9FC), Color(0xFFEEF3FF)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
    );
  }
}

class _FloatingShapes extends StatelessWidget {
  final double progress; // 0..1
  const _FloatingShapes({required this.progress});
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    Widget blob(Color c, double size, double px, double py) => Positioned(
      left: px,
      top: py,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: c.withOpacity(.12),
            boxShadow: [BoxShadow(color: c.withOpacity(.08), blurRadius: 24)]),
      ),
    );
    double x(double r, double phase) => (w / 2) + r * math.cos(2 * math.pi * progress + phase);
    double y(double r, double phase) => (h / 3) + r * math.sin(2 * math.pi * progress + phase);

    return IgnorePointer(
      child: Stack(children: [
        blob(Colors.purple, 160, x(120, 0),   y(80, 0)),
        blob(Colors.blue,   120, x(100, 1.2), y(70, 1.2)),
        blob(Colors.teal,   140, x(140, 2.2), y(90, 2.2)),
        blob(Colors.pink,   110, x(90, 3.5),  y(60, 3.5)),
      ]),
    );
  }
}
