import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';

class SecurityActivitySummary {
  final int score;
  final String status;
  final String message;
  final bool recentHighRisk;
  final bool recentSuspicious;
  final int recentHighRiskCount;
  final int recentSuspiciousCount;
  final int activityCount;

  const SecurityActivitySummary({
    required this.score,
    required this.status,
    required this.message,
    required this.recentHighRisk,
    required this.recentSuspicious,
    required this.recentHighRiskCount,
    required this.recentSuspiciousCount,
    required this.activityCount,
  });

  factory SecurityActivitySummary.fromJson(
    Map<String, dynamic> json,
  ) {
    return SecurityActivitySummary(
      score: json['score'] as int? ?? 100,
      status: json['status'] as String,
      message: json['message'] as String,
      recentHighRisk: json['recent_high_risk'] as bool? ?? false,
      recentSuspicious: json['recent_suspicious'] as bool? ?? false,
      recentHighRiskCount: json['recent_high_risk_count'] as int? ?? 0,
      recentSuspiciousCount: json['recent_suspicious_count'] as int? ?? 0,
      activityCount: json['activity_count'] as int? ?? 0,
    );
  }
}

class SecurityActivity {
  final int id;
  final String activityType;
  final String riskLevel;
  final int riskScore;
  final DateTime createdAt;

  const SecurityActivity({
    required this.id,
    required this.activityType,
    required this.riskLevel,
    required this.riskScore,
    required this.createdAt,
  });

  factory SecurityActivity.fromJson(
    Map<String, dynamic> json,
  ) {
    return SecurityActivity(
      id: json['id'] as int,
      activityType: json['activity_type'] as String,
      riskLevel: json['risk_level'] as String,
      riskScore: json['risk_score'] as int,
      createdAt: DateTime.parse(
        json['created_at'] as String,
      ),
    );
  }
}

class SecurityActivityService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<SecurityActivitySummary> getSummary() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse(
        '${ApiConfig.baseUrl}/api/activity/summary',
      ),
      headers: _headers(token),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return SecurityActivitySummary.fromJson(
        data as Map<String, dynamic>,
      );
    }

    _handleError(response);

    throw Exception(
      'Unable to load security summary.',
    );
  }

  Future<List<SecurityActivity>> getActivity() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse(
        '${ApiConfig.baseUrl}/api/activity',
      ),
      headers: _headers(token),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;

      return data
          .map(
            (item) => SecurityActivity.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList();
    }

    _handleError(response);

    throw Exception(
      'Unable to load security activity.',
    );
  }

  Future<String> _getToken() async {
    final token = await _storage.read(
      key: 'access_token',
    );

    if (token == null || token.isEmpty) {
      throw Exception(
        'Authentication token not found.',
      );
    }

    return token;
  }

  Map<String, String> _headers(
    String token,
  ) {
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  void _handleError(
    http.Response response,
  ) {
    if (response.statusCode == 401) {
      throw Exception(
        'Your session has expired. Please log in again.',
      );
    }

    throw Exception(
      'Request failed (${response.statusCode}).',
    );
  }
}
