import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'modules/navigation/routes.dart';
import 'modules/navigation/router.dart';
import 'modules/settings/models/settings_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settings = await SettingsModel.load();
  runApp(MiniGamesApp(settings: settings));
}

class MiniGamesApp extends StatelessWidget {
  final SettingsModel settings;
  const MiniGamesApp({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: settings,
      builder: (_, __) {
        final themeBase = ThemeData(
          colorSchemeSeed: const Color(0xFF4A86E8),
          useMaterial3: true,
          textTheme: GoogleFonts.poppinsTextTheme(),
        );
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Mini Games',
          theme: settings.darkMode ? ThemeData.dark(useMaterial3: true) : themeBase,
          initialRoute: AppRoutes.splash,
          onGenerateRoute: (settingsRoute) =>
              AppRouter.onGenerateRoute(settingsRoute, appSettings: settings),
        );
      },
    );
  }
}
