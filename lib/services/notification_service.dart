import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';

class AppNotification {
  final int id;
  final String title;
  final String message;
  final String notificationType;
  final bool isRead;
  final DateTime createdAt;

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.notificationType,
    required this.isRead,
    required this.createdAt,
  });

  factory AppNotification.fromJson(
    Map<String, dynamic> json,
  ) {
    return AppNotification(
      id: json['id'] as int,
      title: json['title'] as String,
      message: json['message'] as String,
      notificationType: json['notification_type'] as String,
      isRead: json['is_read'] as bool,
      createdAt: DateTime.parse(
        json['created_at'] as String,
      ),
    );
  }
}

class NotificationService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

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

  Map<String, String> _headers(String token) {
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<List<AppNotification>> getNotifications() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse(
        '${ApiConfig.baseUrl}/api/notifications',
      ),
      headers: _headers(token),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;

      return data
          .map(
            (item) => AppNotification.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList();
    }

    throw Exception(
      'Failed to load notifications '
      '(${response.statusCode}).',
    );
  }

  Future<int> getUnreadCount() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse(
        '${ApiConfig.baseUrl}/api/notifications/unread-count',
      ),
      headers: _headers(token),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      return data['count'] as int;
    }

    throw Exception(
      'Failed to load notification count '
      '(${response.statusCode}).',
    );
  }

  Future<AppNotification> markAsRead(
    int notificationId,
  ) async {
    final token = await _getToken();

    final response = await http.patch(
      Uri.parse(
        '${ApiConfig.baseUrl}/api/notifications/'
        '$notificationId/read',
      ),
      headers: _headers(token),
    );

    if (response.statusCode == 200) {
      return AppNotification.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }

    throw Exception(
      'Failed to update notification '
      '(${response.statusCode}).',
    );
  }

  Future<void> markAllAsRead() async {
    final token = await _getToken();

    final response = await http.patch(
      Uri.parse(
        '${ApiConfig.baseUrl}/api/notifications/read-all',
      ),
      headers: _headers(token),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to mark notifications as read '
        '(${response.statusCode}).',
      );
    }
  }
}
