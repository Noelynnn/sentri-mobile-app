import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/analysis_result.dart';
import '../models/risk_level.dart';
import 'auth_api_service.dart';
import 'auth_storage_service.dart';

class PhishingAnalysisService {
  final AuthStorageService _storageService = AuthStorageService();

  Future<AnalysisResult> analyze(String url) async {
    final token = await _storageService.getToken();

    if (token == null || token.isEmpty) {
      throw const ApiException(
        'You are not authenticated. Please log in again.',
      );
    }

    final endpoint = Uri.parse(
      '${ApiConfig.baseUrl}/api/phishing/analyze',
    );

    try {
      final response = await http.post(
        endpoint,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'url': url.trim(),
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        return AnalysisResult(
          riskLevel: _parseRiskLevel(
            data['risk_level'] as String,
          ),
          riskScore: data['risk_score'] as int,
          message: data['message'] as String,
          reasons: List<String>.from(
            data['reasons'] as List,
          ),
          recommendation: data['recommendation'] as String,
        );
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

  RiskLevel _parseRiskLevel(String value) {
    switch (value) {
      case 'safe':
        return RiskLevel.safe;

      case 'suspicious':
        return RiskLevel.suspicious;

      case 'highRisk':
        return RiskLevel.highRisk;

      default:
        throw const ApiException(
          'The server returned an unknown risk level.',
        );
    }
  }

  String _extractErrorMessage(http.Response response) {
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
