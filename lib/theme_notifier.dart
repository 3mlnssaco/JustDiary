import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeData _currentTheme;

  ThemeNotifier(this._currentTheme);

  ThemeData getTheme() => _currentTheme;

  void setTheme(ThemeData theme) {
    _currentTheme = theme;
    notifyListeners();
  }
}
