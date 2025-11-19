import 'package:flutter/material.dart';

class ThemeModeState with ChangeNotifier {
  final cornerRadius = 15.0;

  final BuildContext context;
  ThemeModeState(this.context);
  ThemeMode get mode => _themeMode;
  var _themeMode = ThemeMode.system;

  void cycleMode() {
    _themeMode = switch (_themeMode) {
      ThemeMode.dark => ThemeMode.light,
      ThemeMode.light => ThemeMode.system,
      ThemeMode.system => ThemeMode.dark,
    };
    notifyListeners();
  }

  IconData get icon => switch (_themeMode) {
    ThemeMode.dark => Icons.dark_mode_outlined,
    ThemeMode.light => Icons.light_mode_outlined,
    ThemeMode.system => Icons.settings,
  };

  String get description => switch (_themeMode) {
    ThemeMode.dark => "Dark mode",
    ThemeMode.light => "Light mode",
    ThemeMode.system => "System brightness",
  };

  Brightness get brightness => switch (_themeMode) {
    ThemeMode.dark => Brightness.dark,
    ThemeMode.light => Brightness.light,
    ThemeMode.system => MediaQuery.platformBrightnessOf(context),
  };
}
