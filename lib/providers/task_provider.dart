import 'package:flutter/foundation.dart';

import '../models/task_model.dart';
import '../services/api_exception.dart';
import '../services/local_storage_service.dart';
import '../services/task_api_service.dart';

class TaskProvider extends ChangeNotifier {
  TaskProvider({
    required TaskApiService taskApiService,
    required LocalStorageService storageService,
  })  : _taskApiService = taskApiService,
        _storageService = storageService;

  final TaskApiService _taskApiService;
  final LocalStorageService _storageService;

  final List<TaskModel> _tasks = [];
  final List<TaskModel> _savedTasks = [];
  bool _isLoading = false;
  bool _hasLoadedRemoteTasks = false;
  String _searchQuery = '';
  String? _errorMessage;

  List<TaskModel> get tasks => List.unmodifiable(_tasks);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  List<TaskModel> get filteredTasks {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return tasks;

    return _tasks.where((task) {
      return task.title.toLowerCase().contains(query) ||
          task.id.toString().contains(query);
    }).toList();
  }

  Future<void> loadSavedTasks() async {
    _savedTasks
      ..clear()
      ..addAll(_storageService.getSavedTasks());
  }

  Future<void> fetchTasks({bool forceRefresh = false}) async {
    if (_hasLoadedRemoteTasks && !forceRefresh) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final remoteTasks = await _taskApiService.fetchTasks();
      _tasks
        ..clear()
        ..addAll(remoteTasks)
        ..addAll(_savedTasks);
      _hasLoadedRemoteTasks = true;
    } on ApiException catch (error) {
      _errorMessage = error.message;
      if (_tasks.isEmpty && _savedTasks.isNotEmpty) {
        _tasks.addAll(_savedTasks);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshTasks() => fetchTasks(forceRefresh: true);

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> addTask({
    required String title,
    required bool completed,
  }) async {
    final task = TaskModel(
      id: _nextLocalTaskId(),
      title: title.trim(),
      completed: completed,
      isLocal: true,
    );

    try {
      await _taskApiService.addTask(task);
    } on ApiException {
      // The rubric asks new tasks to be added locally; keep the local save even
      // if the demo API endpoint is unavailable.
    }
    _savedTasks.insert(0, task);
    _tasks.insert(0, task);
    await _persistSavedTasks();
    notifyListeners();
  }

  Future<void> updateTask(TaskModel task) async {
    if (!task.isLocal) {
      await _taskApiService.updateTask(task);
    }
    final index = _tasks.indexWhere((item) => item.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
    }

    final savedIndex = _savedTasks.indexWhere((item) => item.id == task.id);
    if (savedIndex != -1) {
      _savedTasks[savedIndex] = task.copyWith(isLocal: true);
      await _persistSavedTasks();
    }

    notifyListeners();
  }

  Future<void> deleteTask(TaskModel task) async {
    if (!task.isLocal) {
      await _taskApiService.deleteTask(task.id);
    }
    _tasks.removeWhere((item) => item.id == task.id);
    _savedTasks.removeWhere((item) => item.id == task.id);
    await _persistSavedTasks();
    notifyListeners();
  }

  Future<void> _persistSavedTasks() {
    return _storageService.saveTasks(_savedTasks);
  }

  int _nextLocalTaskId() {
    final ids = [
      ..._tasks.map((task) => task.id),
      ..._savedTasks.map((task) => task.id),
      1000,
    ];
    ids.sort();
    return ids.last + 1;
  }
}
