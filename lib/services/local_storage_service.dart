import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/task_model.dart';
import '../models/user_model.dart';

class LocalStorageService {
  static const _userKey = 'login_session';
  static const _tasksKey = 'added_tasks';
  static const _themeKey = 'is_dark_mode';

  late final SharedPreferences _preferences;

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<void> saveUser(UserModel user) async {
    await _preferences.setString(_userKey, jsonEncode(user.toJson()));
  }

  UserModel? getUser() {
    final userJson = _preferences.getString(_userKey);
    if (userJson == null) return null;
    return UserModel.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
  }

  Future<void> clearUser() async {
    await _preferences.remove(_userKey);
  }

  Future<void> saveTasks(List<TaskModel> tasks) async {
    final data = tasks.map((task) => task.toJson()).toList();
    await _preferences.setString(_tasksKey, jsonEncode(data));
  }

  List<TaskModel> getSavedTasks() {
    final tasksJson = _preferences.getString(_tasksKey);
    if (tasksJson == null) return [];
    final data = jsonDecode(tasksJson) as List<dynamic>;
    return data
        .map((item) => TaskModel.fromJson(
              item as Map<String, dynamic>,
              isLocal: true,
            ))
        .toList();
  }

  bool isDarkMode() => _preferences.getBool(_themeKey) ?? false;

  Future<void> saveDarkMode(bool isDarkMode) async {
    await _preferences.setBool(_themeKey, isDarkMode);
  }
}
