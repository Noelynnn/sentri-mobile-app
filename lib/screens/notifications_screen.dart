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

  String? _errorMessage;

  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final notifications = await _notificationService.getNotifications();

      if (!mounted) {
        return;
      }

      setState(() {
        _notifications = notifications;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage = 'Unable to load notifications.';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
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

      if (!mounted) {
        return;
      }

      setState(() {
        _notifications = _notifications.map(
          (item) {
            if (item.id == updated.id) {
              return updated;
            }

            return item;
          },
        ).toList();
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
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

    final hasUnread = _notifications.any(
      (notification) => !notification.isRead,
    );

    if (!hasUnread) {
      return;
    }

    setState(() {
      _isMarkingAllRead = true;
    });

    try {
      await _notificationService.markAllAsRead();

      if (!mounted) {
        return;
      }

      setState(() {
        _notifications = _notifications.map(
          (item) {
            return AppNotification(
              id: item.id,
              title: item.title,
              message: item.message,
              notificationType: item.notificationType,
              isRead: true,
              createdAt: item.createdAt,
            );
          },
        ).toList();

        _isMarkingAllRead = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isMarkingAllRead = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Unable to mark notifications as read.',
          ),
        ),
      );
    }
  }

  List<AppNotification> get _filteredNotifications {
    switch (_selectedFilter) {
      case 'Unread':
        return _notifications
            .where(
              (notification) => !notification.isRead,
            )
            .toList();

      case 'High Risk':
        return _notifications
            .where(
              (notification) =>
                  _notificationRisk(
                    notification,
                  ) ==
                  'highRisk',
            )
            .toList();

      case 'Suspicious':
        return _notifications
            .where(
              (notification) =>
                  _notificationRisk(
                    notification,
                  ) ==
                  'suspicious',
            )
            .toList();

      case 'All':
      default:
        return _notifications;
    }
  }

  String _notificationRisk(
    AppNotification notification,
  ) {
    final title = notification.title.toLowerCase();

    if (title.contains('high-risk') || title.contains('high risk')) {
      return 'highRisk';
    }

    if (title.contains('suspicious')) {
      return 'suspicious';
    }

    return 'safe';
  }

  Color _notificationColor(
    AppNotification notification,
  ) {
    switch (_notificationRisk(notification)) {
      case 'highRisk':
        return AppColors.highRisk;

      case 'suspicious':
        return AppColors.suspicious;

      case 'safe':
      default:
        return AppColors.safe;
    }
  }

  Color _notificationBackground(
    AppNotification notification,
  ) {
    switch (_notificationRisk(notification)) {
      case 'highRisk':
        return AppColors.highRiskBackground;

      case 'suspicious':
        return AppColors.suspiciousBackground;

      case 'safe':
      default:
        return AppColors.safeBackground;
    }
  }

  IconData _notificationIcon(
    AppNotification notification,
  ) {
    final type = notification.notificationType.toLowerCase();

    if (type.contains('phishing')) {
      return Icons.link_rounded;
    }

    if (type.contains('scam')) {
      return Icons.security_rounded;
    }

    return Icons.shield_outlined;
  }

  String _formatDateTime(
    DateTime value,
  ) {
    final date = value.toLocal();
    final now = DateTime.now();

    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final notificationDay = DateTime(
      date.year,
      date.month,
      date.day,
    );

    final difference = today.difference(notificationDay).inDays;

    final time = _formatTime(date);

    if (difference == 0) {
      return 'Today • $time';
    }

    if (difference == 1) {
      return 'Yesterday • $time';
    }

    if (difference < 7) {
      return '${_weekdayName(date.weekday)} • $time';
    }

    return '${_monthName(date.month)} '
        '${date.day} • $time';
  }

  String _formatTime(
    DateTime date,
  ) {
    final hour = date.hour == 0
        ? 12
        : date.hour > 12
            ? date.hour - 12
            : date.hour;

    final minute = date.minute.toString().padLeft(2, '0');

    final period = date.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }

  String _weekdayName(
    int weekday,
  ) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return weekdays[weekday - 1];
  }

  String _monthName(
    int month,
  ) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return months[month - 1];
  }

  String _filterDescription() {
    switch (_selectedFilter) {
      case 'Unread':
        return 'Notifications you have not opened yet.';

      case 'High Risk':
        return 'Notifications related to high-risk security detections.';

      case 'Suspicious':
        return 'Notifications related to suspicious activity.';

      case 'All':
      default:
        return 'Security alerts and updates from Sentri.';
    }
  }

  Widget _buildFilterChip(
    String label,
  ) {
    final isSelected = _selectedFilter == label;

    Color color;

    switch (label) {
      case 'High Risk':
        color = AppColors.highRisk;
        break;

      case 'Suspicious':
        color = AppColors.suspicious;
        break;

      case 'Unread':
      case 'All':
      default:
        color = AppColors.primary;
    }

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        setState(() {
          _selectedFilter = label;
        });
      },
      selectedColor: color.withOpacity(0.12),
      backgroundColor: AppColors.white,
      side: BorderSide(
        color: isSelected ? color.withOpacity(0.35) : AppColors.border,
      ),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: isSelected ? color : AppColors.textSecondary,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
      ),
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
      ),
    );
  }

  Widget _buildHeaderSummary(
    int unreadCount,
  ) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.primary,
              size: 23,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  unreadCount == 0
                      ? 'You are all caught up'
                      : '$unreadCount unread '
                          '${unreadCount == 1 ? 'notification' : 'notifications'}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _filterDescription(),
                  style: const TextStyle(
                    fontSize: 12.5,
                    height: 1.4,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(
    AppNotification notification,
  ) {
    final color = _notificationColor(notification);

    final background = _notificationBackground(
      notification,
    );

    final isUnread = !notification.isRead;

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () => _markAsRead(notification),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isUnread ? background : AppColors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isUnread ? color.withOpacity(0.20) : AppColors.border,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: isUnread ? AppColors.white : AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(
                    15,
                  ),
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
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight:
                                  isUnread ? FontWeight.w800 : FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                        if (isUnread)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(
                              top: 5,
                              left: 8,
                            ),
                            decoration: BoxDecoration(
                              color: color,
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
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule_outlined,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          _formatDateTime(
                            notification.createdAt,
                          ),
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
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

  Widget _buildFilteredEmptyState() {
    final isUnread = _selectedFilter == 'Unread';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 30,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.safeBackground,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.check_circle_outline,
              color: AppColors.safe,
              size: 30,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            isUnread ? 'You are all caught up' : 'Nothing here yet',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            isUnread
                ? 'You have no unread notifications.'
                : 'No notifications match this filter.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoNotificationsState() {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _loadNotifications,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          20,
          100,
          20,
          30,
        ),
        children: [
          Center(
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(
                  22,
                ),
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: AppColors.primary,
                size: 36,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No notifications yet',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 21,
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
      ),
    );
  }

  Widget _buildErrorState() {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _loadNotifications,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 90),
          const Icon(
            Icons.cloud_off_rounded,
            size: 52,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 16),
          const Text(
            'Couldn’t load notifications',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Check your connection and try again.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.5,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 22),
          Center(
            child: ElevatedButton(
              onPressed: _loadNotifications,
              child: const Text(
                'Try Again',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsContent(
    int unreadCount,
    List<AppNotification> notifications,
  ) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        20,
        12,
        20,
        32,
      ),
      children: [
        _buildHeaderSummary(
          unreadCount,
        ),
        const SizedBox(height: 18),
        SizedBox(
          height: 42,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildFilterChip('All'),
              const SizedBox(width: 8),
              _buildFilterChip('Unread'),
              const SizedBox(width: 8),
              _buildFilterChip('High Risk'),
              const SizedBox(width: 8),
              _buildFilterChip('Suspicious'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (notifications.isEmpty)
          _buildFilteredEmptyState()
        else ...[
          Text(
            '${notifications.length} '
            '${notifications.length == 1 ? 'notification' : 'notifications'}',
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          ...notifications.map(
            (notification) {
              return Padding(
                padding: const EdgeInsets.only(
                  bottom: 12,
                ),
                child: _buildNotificationCard(
                  notification,
                ),
              );
            },
          ),
        ],
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

    final filteredNotifications = _filteredNotifications;

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
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              )
            : _errorMessage != null
                ? _buildErrorState()
                : _notifications.isEmpty
                    ? _buildNoNotificationsState()
                    : RefreshIndicator(
                        color: AppColors.primary,
                        onRefresh: _loadNotifications,
                        child: _buildNotificationsContent(
                          unreadCount,
                          filteredNotifications,
                        ),
                      ),
      ),
    );
  }
}
