import 'package:flutter/material.dart';

import '../services/local_storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider({required LocalStorageService storageService})
      : _storageService = storageService;

  final LocalStorageService _storageService;

  bool _isDarkMode = false;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  bool get isDarkMode => _isDarkMode;

  Future<void> loadTheme() async {
    _isDarkMode = _storageService.isDarkMode();
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _storageService.saveDarkMode(_isDarkMode);
    notifyListeners();
  }
}
