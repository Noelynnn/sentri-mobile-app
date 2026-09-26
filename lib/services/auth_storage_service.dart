import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorageService {
  static const String _tokenKey = 'access_token';
  static const String _rememberMeKey = 'remember_me';
  static const String _userNameKey = 'user_name';

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

  Future<void> saveUserName(String fullName) async {
    await _storage.write(
      key: _userNameKey,
      value: fullName.trim(),
    );
  }

  Future<String?> getUserName() async {
    return await _storage.read(
      key: _userNameKey,
    );
  }

  Future<void> clearSession() async {
    await _storage.delete(
      key: _tokenKey,
    );

    await _storage.delete(
      key: _rememberMeKey,
    );
  }
}
