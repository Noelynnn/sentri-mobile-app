import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorageService {
  static const String _tokenKey = 'access_token';
  static const String _rememberMeKey = 'remember_me';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(
      key: _tokenKey,
      value: token,
    );
  }

  Future<String?> getToken() async {
    return await _storage.read(
      key: _tokenKey,
    );
  }

  Future<void> deleteToken() async {
    await _storage.delete(
      key: _tokenKey,
    );
  }

  Future<void> saveRememberMe(bool value) async {
    await _storage.write(
      key: _rememberMeKey,
      value: value.toString(),
    );
  }

  Future<bool> getRememberMe() async {
    final value = await _storage.read(
      key: _rememberMeKey,
    );

    return value == 'true';
  }

  Future<void> deleteRememberMe() async {
    await _storage.delete(
      key: _rememberMeKey,
    );
  }

  Future<void> clearAuthData() async {
    await _storage.delete(
      key: _tokenKey,
    );

    await _storage.delete(
      key: _rememberMeKey,
    );
  }
}
