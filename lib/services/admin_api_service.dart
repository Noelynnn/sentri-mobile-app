import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/admin_models.dart';
import 'auth_api_service.dart';
import 'auth_storage_service.dart';

class AdminApiService {
  final AuthStorageService _storageService = AuthStorageService();

  Future<Map<String, String>> _headers() async {
    final token = await _storageService.getToken();

    if (token == null || token.isEmpty) {
      throw const ApiException(
        'Your session has expired. Please log in again.',
      );
    }

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<AdminDashboardStats> getDashboardStats() async {
    final response = await _get(
      '/api/admin/dashboard',
    );

    return AdminDashboardStats.fromJson(
      response as Map<String, dynamic>,
    );
  }

  Future<List<AdminUser>> getUsers() async {
    final response = await _get(
      '/api/admin/users',
    );

    final data = response as List<dynamic>;

    return data
        .map(
          (item) => AdminUser.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<List<AdminReport>> getReports() async {
    final response = await _get(
      '/api/admin/reports',
    );

    final data = response as List<dynamic>;

    return data
        .map(
          (item) => AdminReport.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<String> updateReportStatus({
    required int reportId,
    required String status,
  }) async {
    final headers = await _headers();

    final response = await http.patch(
      Uri.parse(
        '${ApiConfig.baseUrl}/api/admin/reports/$reportId/status',
      ),
      headers: headers,
      body: jsonEncode({
        'status': status,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      return data['status']?.toString() ?? status;
    }

    throw ApiException(
      _extractErrorMessage(response),
      statusCode: response.statusCode,
    );
  }

  Future<dynamic> _get(
    String path,
  ) async {
    final headers = await _headers();

    final response = await http.get(
      Uri.parse(
        '${ApiConfig.baseUrl}$path',
      ),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw ApiException(
      _extractErrorMessage(response),
      statusCode: response.statusCode,
    );
  }

  String _extractErrorMessage(
    http.Response response,
  ) {
    try {
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      final detail = data['detail'];

      if (detail is String) {
        return detail;
      }

      if (detail is List && detail.isNotEmpty) {
        final first = detail.first;

        if (first is Map && first['msg'] != null) {
          return first['msg'].toString();
        }
      }

      return 'Request failed with status ${response.statusCode}.';
    } catch (_) {
      return 'Request failed with status ${response.statusCode}.';
    }
  }
}
