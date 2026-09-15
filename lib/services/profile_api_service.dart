import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../config/api_config.dart';
import 'auth_api_service.dart';

class ProfileApiService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String> _getToken() async {
    final token = await _storage.read(
      key: 'access_token',
    );

    if (token == null || token.isEmpty) {
      throw const ApiException(
        'Authentication token not found.',
      );
    }

    return token;
  }

  MediaType? _getImageContentType(
    String filename,
  ) {
    final extension = filename.toLowerCase().split('.').last;

    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');

      case 'png':
        return MediaType('image', 'png');

      case 'webp':
        return MediaType('image', 'webp');

      default:
        return null;
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    required String fullName,
    List<int>? imageBytes,
    String? imageFilename,
  }) async {
    final token = await _getToken();

    final request = http.MultipartRequest(
      'PATCH',
      Uri.parse(
        '${ApiConfig.baseUrl}/api/auth/me',
      ),
    );

    request.headers['Authorization'] = 'Bearer $token';

    request.fields['full_name'] = fullName.trim();

    if (imageBytes != null && imageBytes.isNotEmpty) {
      final filename = imageFilename ?? 'profile_image.jpg';

      final contentType = _getImageContentType(filename);

      if (contentType == null) {
        throw const ApiException(
          'Only JPEG, PNG, and WebP images are allowed.',
        );
      }

      request.files.add(
        http.MultipartFile.fromBytes(
          'profile_image',
          imageBytes,
          filename: filename,
          contentType: contentType,
        ),
      );
    }

    final streamedResponse = await request.send();

    final response = await http.Response.fromStream(
      streamedResponse,
    );

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(
        jsonDecode(response.body),
      );
    }

    String message = 'Unable to update your profile.';

    try {
      final data = jsonDecode(
        response.body,
      );

      if (data is Map && data['detail'] is String) {
        message = data['detail'] as String;
      }
    } catch (_) {
      // Keep the fallback message.
    }

    throw ApiException(
      message,
      statusCode: response.statusCode,
    );
  }

  Future<Map<String, dynamic>> getProfile() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse(
        '${ApiConfig.baseUrl}/api/auth/me',
      ),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(
        jsonDecode(response.body),
      );
    }

    throw ApiException(
      'Unable to load your profile.',
      statusCode: response.statusCode,
    );
  }

  Future<Map<String, dynamic>> removeProfileImage() async {
    final token = await _getToken();

    final response = await http.delete(
      Uri.parse(
        '${ApiConfig.baseUrl}/api/auth/me/profile-image',
      ),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(
        jsonDecode(response.body),
      );
    }

    throw ApiException(
      'Unable to remove your profile picture.',
      statusCode: response.statusCode,
    );
  }
}
