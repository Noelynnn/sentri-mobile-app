import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/report.dart';
import 'auth_storage_service.dart';
import 'auth_api_service.dart';

class ReportApiService {
  final AuthStorageService _storageService = AuthStorageService();

  Future<Report> submitReport({
    required String incidentType,
    required String description,
    String? additionalDetails,
  }) async {
    final token = await _storageService.getToken();

    if (token == null || token.isEmpty) {
      throw const ApiException(
        'You are not authenticated. Please log in again.',
      );
    }

    final url = Uri.parse(
      '${ApiConfig.baseUrl}/api/reports',
    );

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'incident_type': incidentType,
          'description': description.trim(),
          'additional_details': additionalDetails?.trim().isEmpty ?? true
              ? null
              : additionalDetails!.trim(),
        }),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        return Report.fromJson(data);
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
