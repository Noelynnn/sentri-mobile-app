import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/auth_response.dart';
import 'auth_storage_service.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(
    this.message, {
    this.statusCode,
  });

  @override
  String toString() {
    return message;
  }
}

class AuthApiService {
  final AuthStorageService _storageService = AuthStorageService();

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse(
      '${ApiConfig.baseUrl}/api/auth/register',
    );

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'full_name': fullName.trim(),
          'email': email.trim(),
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        return;
      }

      throw ApiException(
        _extractErrorMessage(response),
        statusCode: response.statusCode,
      );
    } on ApiException {
      rethrow;
    } on http.ClientException {
      throw const ApiException(
        'Unable to connect to the Sentri server. '
        'Please make sure the backend is running.',
      );
    } catch (e) {
      throw ApiException(
        'Something went wrong: $e',
      );
    }
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse(
      '${ApiConfig.baseUrl}/api/auth/login',
    );

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email.trim(),
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        final authResponse = AuthResponse.fromJson(data);

        await _storageService.saveToken(
          authResponse.accessToken,
        );

        return authResponse;
      }

      throw ApiException(
        _extractErrorMessage(response),
        statusCode: response.statusCode,
      );
    } on ApiException {
      rethrow;
    } on http.ClientException {
      throw const ApiException(
        'Unable to connect to the Sentri server. '
        'Please make sure the backend is running.',
      );
    } on FormatException {
      throw const ApiException(
        'The server returned an invalid response.',
      );
    } catch (e) {
      throw ApiException(
        'Something went wrong: $e',
      );
    }
  }

  Future<String?> getStoredToken() async {
    return await _storageService.getToken();
  }

  Future<void> logout() async {
    await _storageService.deleteToken();
  }

  String _extractErrorMessage(
    http.Response response,
  ) {
    try {
      final Map<String, dynamic> data = jsonDecode(response.body);

      final detail = data['detail'];

      if (detail is String) {
        return detail;
      }

      if (detail is List && detail.isNotEmpty) {
        final firstError = detail.first;

        if (firstError is Map && firstError['msg'] != null) {
          return firstError['msg'].toString();
        }
      }

      return 'Request failed with status ${response.statusCode}.';
    } catch (_) {
      return 'Request failed with status ${response.statusCode}.';
    }
  }
}
