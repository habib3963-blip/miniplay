import 'package:flutter/material.dart';

import '../auth/screens/login.dart';
import '../auth/screens/signup_screen.dart';
import '../ui/splash_screen.dart';
import '../ui/home_screen.dart';
import '../scoreboard/screens/scoreboard_screen.dart';
import '../settings/screens/settings_screen.dart';
import '../games/screens/tic_tac_toe_screen.dart';
import '../settings/models/settings_model.dart';
import 'routes.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings rs, {required SettingsModel appSettings}) {
    switch (rs.name) {
      case AppRoutes.splash:
        return _page(const SplashScreen());
      case AppRoutes.login:
        return _page(const LoginPage());
      case AppRoutes.signup:
        return _page(const SignupPage());
      case AppRoutes.home:
        return _page(HomeScreen(settings: appSettings));
      case AppRoutes.scoreboard:
        return _page(const ScoreboardScreen());
      case AppRoutes.settings:
        return _page(SettingsScreen(settings: appSettings));
      case AppRoutes.ticTacToe:
        return _page(const TicTacToeScreen());
      default:
        return _page(const SplashScreen());
    }
  }

  static MaterialPageRoute _page(Widget child) =>
      MaterialPageRoute(builder: (_) => child);
}
