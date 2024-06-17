import 'package:cartly/services/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode =(isDark)? ThemeMode.dark:ThemeMode.light;
  bool get isDarkMode => themeMode == ThemeMode.dark;

  Future<void> toggleTheme() async {

    themeMode = themeMode!=ThemeMode.dark ? ThemeMode.dark : ThemeMode.light;
    await SharedPrefs().setTheme(themeMode==ThemeMode.dark);
    debugPrint('Called toggle $isDarkMode');

    notifyListeners();
  }

}
