import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../config/api_config.dart';
import '../models/report.dart';
import 'auth_api_service.dart';
import 'auth_storage_service.dart';

class ReportApiService {
  final AuthStorageService _storageService = AuthStorageService();

  Future<List<Report>> getReports() async {
    final token = await _storageService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('Authentication token not found.');
    }

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/api/reports'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data
          .map(
            (json) => Report.fromJson(
              json as Map<String, dynamic>,
            ),
          )
          .toList();
    }

    if (response.statusCode == 401) {
      throw Exception('Your session has expired. Please log in again.');
    }

    throw Exception(
      'Failed to load reports (${response.statusCode}).',
    );
  }

  Future<Report> submitReport({
    required String incidentType,
    required String description,
    String? additionalDetails,
    List<XFile> evidence = const [],
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
      final request = http.MultipartRequest(
        'POST',
        url,
      );

      request.headers['Authorization'] = 'Bearer $token';

      request.fields['incident_type'] = incidentType.trim();

      request.fields['description'] = description.trim();

      if (additionalDetails != null && additionalDetails.trim().isNotEmpty) {
        request.fields['additional_details'] = additionalDetails.trim();
      }

      for (final image in evidence) {
        final bytes = await image.readAsBytes();

        request.files.add(
          http.MultipartFile.fromBytes(
            'evidence',
            bytes,
            filename: image.name,
          ),
        );
      }

      final streamedResponse = await request.send();

      final response = await http.Response.fromStream(
        streamedResponse,
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

      return 'Request failed with status '
          '${response.statusCode}.';
    } catch (_) {
      return 'Request failed with status '
          '${response.statusCode}.';
    }
  }
}
