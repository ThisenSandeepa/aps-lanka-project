import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../services/api_exception.dart';
import '../services/auth_service.dart';
import '../services/local_storage_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({
    required AuthService authService,
    required LocalStorageService storageService,
  })  : _authService = authService,
        _storageService = storageService;

  final AuthService _authService;
  final LocalStorageService _storageService;

  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null && _user!.token.isNotEmpty;

  Future<void> restoreSession() async {
    _user = _storageService.getUser();
    notifyListeners();
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _authService.login(email: email, password: password);
      await _storageService.saveUser(_user!);
      return true;
    } on ApiException catch (error) {
      _errorMessage = error.message;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _user = null;
    await _storageService.clearUser();
    notifyListeners();
  }
}
