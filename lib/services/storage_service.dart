import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  StorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const _tokenKey = 'motoh_jwt';
  static const _onboardingKey = 'motoh_onboarding_done';

  final FlutterSecureStorage _storage;

  Future<void> saveToken(String token) => _storage.write(key: _tokenKey, value: token);

  Future<String?> readToken() => _storage.read(key: _tokenKey);

  Future<void> clearToken() => _storage.delete(key: _tokenKey);

  Future<void> setOnboardingComplete(bool done) async {
    await _storage.write(key: _onboardingKey, value: done ? '1' : '0');
  }

  Future<bool> isOnboardingComplete() async {
    final v = await _storage.read(key: _onboardingKey);
    return v == '1';
  }
}
