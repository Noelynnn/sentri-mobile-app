import 'package:flutter/material.dart';

import '../services/notification_service.dart';
import '../theme/app_colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({
    super.key,
  });

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationService _notificationService = NotificationService();

  List<AppNotification> _notifications = [];

  bool _isLoading = true;
  bool _isMarkingAllRead = false;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final notifications = await _notificationService.getNotifications();

      if (!mounted) return;

      setState(() {
        _notifications = notifications;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.highRisk,
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Unable to load notifications.',
          ),
        ),
      );
    }
  }

  Future<void> _markAsRead(
    AppNotification notification,
  ) async {
    if (notification.isRead) {
      return;
    }

    try {
      final updated = await _notificationService.markAsRead(
        notification.id,
      );

      if (!mounted) return;

      setState(() {
        _notifications = _notifications.map((item) {
          if (item.id == updated.id) {
            return updated;
          }

          return item;
        }).toList();
      });
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.highRisk,
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Unable to update notification.',
          ),
        ),
      );
    }
  }

  Future<void> _markAllAsRead() async {
    if (_isMarkingAllRead) {
      return;
    }

    setState(() {
      _isMarkingAllRead = true;
    });

    try {
      await _notificationService.markAllAsRead();

      if (!mounted) return;

      setState(() {
        _notifications = _notifications.map((item) {
          return AppNotification(
            id: item.id,
            title: item.title,
            message: item.message,
            notificationType: item.notificationType,
            isRead: true,
            createdAt: item.createdAt,
          );
        }).toList();

        _isMarkingAllRead = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isMarkingAllRead = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.highRisk,
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Unable to mark notifications as read.',
          ),
        ),
      );
    }
  }

  Color _notificationColor(
    AppNotification notification,
  ) {
    if (notification.notificationType.toLowerCase().contains('phishing')) {
      return AppColors.suspicious;
    }

    return AppColors.highRisk;
  }

  Color _notificationBackground(
    AppNotification notification,
  ) {
    if (notification.notificationType.toLowerCase().contains('phishing')) {
      return AppColors.suspiciousBackground;
    }

    return AppColors.highRiskBackground;
  }

  IconData _notificationIcon(
    AppNotification notification,
  ) {
    if (notification.notificationType.toLowerCase().contains('phishing')) {
      return Icons.link_rounded;
    }

    return Icons.security_rounded;
  }

  String _formatTime(DateTime value) {
    final date = value.toLocal();

    final hour = date.hour == 0
        ? 12
        : date.hour > 12
            ? date.hour - 12
            : date.hour;

    final minute = date.minute.toString().padLeft(2, '0');

    final period = date.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }

  Widget _buildNotificationCard(
    AppNotification notification,
  ) {
    final color = _notificationColor(notification);

    final background = _notificationBackground(notification);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _markAsRead(notification),
        child: Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: notification.isRead ? AppColors.white : background,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: notification.isRead
                  ? AppColors.border
                  : color.withOpacity(0.2),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: notification.isRead
                      ? AppColors.primaryLight
                      : AppColors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  _notificationIcon(
                    notification,
                  ),
                  color: color,
                  size: 23,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(
                              top: 5,
                              left: 8,
                            ),
                            decoration: const BoxDecoration(
                              color: AppColors.highRisk,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notification.message,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.45,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      _formatTime(
                        notification.createdAt,
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        20,
        90,
        20,
        30,
      ),
      children: [
        Container(
          width: 66,
          height: 66,
          margin: const EdgeInsets.symmetric(
            horizontal: 130,
          ),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.notifications_none_rounded,
            color: AppColors.primary,
            size: 34,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'No notifications yet',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Sentri will notify you when a security check needs your attention.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications
        .where(
          (notification) => !notification.isRead,
        )
        .length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _isMarkingAllRead ? null : _markAllAsRead,
              child: _isMarkingAllRead
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    )
                  : const Text(
                      'Mark all read',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            )
          : _notifications.isEmpty
              ? RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: _loadNotifications,
                  child: _buildEmptyState(),
                )
              : RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: _loadNotifications,
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      12,
                      20,
                      30,
                    ),
                    itemCount: _notifications.length,
                    separatorBuilder: (
                      context,
                      index,
                    ) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _buildNotificationCard(
                        _notifications[index],
                      );
                    },
                  ),
                ),
    );
  }
}
