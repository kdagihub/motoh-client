import 'package:flutter/foundation.dart';

import '../models/api_error.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({
    required AuthService authService,
    required StorageService storageService,
  })  : _auth = authService,
        _storage = storageService;

  final AuthService _auth;
  final StorageService _storage;

  User? _user;
  String? _token;
  bool _loading = false;
  String? _error;

  User? get user => _user;
  String? get token => _token;
  bool get isAuthenticated => _token != null && _token!.isNotEmpty;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> bootstrap() async {
    _token = await _storage.readToken();
    if (isAuthenticated) {
      _loading = true;
      notifyListeners();
      try {
        _user = await _auth.fetchMe();
        _error = null;
      } on ApiError catch (e) {
        _error = e.message;
        if (e.code == 'HTTP_401') {
          await logout();
        }
      } catch (e) {
        _error = e.toString();
      } finally {
        _loading = false;
        notifyListeners();
      }
    } else {
      notifyListeners();
    }
  }

  Future<({String userId, String message})> requestOtp(String phoneE164) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final r = await _auth.requestOtp(phoneE164);
      _loading = false;
      notifyListeners();
      return r;
    } on ApiError catch (e) {
      _error = e.message;
      _loading = false;
      notifyListeners();
      rethrow;
    } catch (e) {
      _error = e.toString();
      _loading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> verifyOtp({required String userId, required String code}) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final r = await _auth.verifyOtp(userId: userId, code: code);
      _token = r.token;
      _user = r.user;
      await _storage.saveToken(r.token);
      _loading = false;
      notifyListeners();
    } on ApiError catch (e) {
      _error = e.message;
      _loading = false;
      notifyListeners();
      rethrow;
    } catch (e) {
      _error = e.toString();
      _loading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> refreshMe() async {
    if (!isAuthenticated) return;
    try {
      _user = await _auth.fetchMe();
      _error = null;
      notifyListeners();
    } on ApiError catch (e) {
      _error = e.message;
      if (e.code == 'HTTP_401') {
        await logout();
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateFullName(String fullName) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _user = await _auth.updateFullName(fullName.trim());
      _loading = false;
      notifyListeners();
    } on ApiError catch (e) {
      _error = e.message;
      _loading = false;
      notifyListeners();
      rethrow;
    } catch (e) {
      _error = e.toString();
      _loading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> logout() async {
    await _storage.clearToken();
    _token = null;
    _user = null;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
