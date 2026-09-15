import 'package:flutter/material.dart';

import '../config/api_config.dart';
import '../models/auth_response.dart';
import '../services/notification_service.dart';
import '../services/profile_api_service.dart';
import '../services/security_activity_service.dart';
import '../theme/app_colors.dart';

import 'edit_profile_screen.dart';
import 'learning_progress_screen.dart';
import 'my_reports_screen.dart';
import 'notifications_screen.dart';
import 'saved_lessons_screen.dart';
import 'security_activity_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String userName;

  const ProfileScreen({
    super.key,
    required this.userName,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final SecurityActivityService _activityService = SecurityActivityService();

  final NotificationService _notificationService = NotificationService();

  final ProfileApiService _profileService = ProfileApiService();

  SecurityActivitySummary? _securitySummary;

  AuthUser? _user;

  int _unreadNotifications = 0;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final results = await Future.wait([
        _activityService.getSummary(),
        _notificationService.getUnreadCount(),
        _profileService.getProfile(),
      ]);

      if (!mounted) return;

      setState(() {
        _securitySummary = results[0] as SecurityActivitySummary;

        _unreadNotifications = results[1] as int;

        _user = AuthUser.fromJson(
          results[2] as Map<String, dynamic>,
        );

        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _editProfile() async {
    final user = _user;

    if (user == null) {
      return;
    }

    final updatedUser = await Navigator.push<AuthUser>(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(
          user: user,
        ),
      ),
    );

    if (!mounted || updatedUser == null) {
      return;
    }

    setState(() {
      _user = updatedUser;
    });
  }

  void _openScreen(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    ).then((_) {
      if (!mounted) return;
      _loadProfileData();
    });
  }

  String get _displayName {
    return _user?.fullName ?? widget.userName;
  }

  String get _email {
    return _user?.email ?? 'Sentri user';
  }

  String get _initials {
    final name = _displayName.trim();

    if (name.isEmpty) {
      return 'U';
    }

    final parts = name
        .split(' ')
        .where(
          (part) => part.isNotEmpty,
        )
        .toList();

    if (parts.length >= 2) {
      return '${parts.first[0]}'
              '${parts.last[0]}'
          .toUpperCase();
    }

    return parts.first[0].toUpperCase();
  }

  String? _imageUrl(String? path) {
    if (path == null || path.isEmpty) {
      return null;
    }

    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }

    return '${ApiConfig.baseUrl}/'
        '${path.replaceFirst('/', '')}';
  }

  Widget _buildAvatar({
    double size = 88,
  }) {
    final imageUrl = _imageUrl(
      _user?.profileImagePath,
    );

    if (imageUrl == null) {
      return _buildInitialAvatar(size);
    }

    return ClipOval(
      child: Image.network(
        imageUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }

          return _buildInitialAvatar(size);
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildInitialAvatar(size);
        },
      ),
    );
  }

  Widget _buildInitialAvatar(
    double size,
  ) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        _initials,
        style: TextStyle(
          color: AppColors.white,
          fontSize: size * 0.31,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(
          26,
        ),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(
                        0.15,
                      ),
                      blurRadius: 14,
                      offset: const Offset(
                        0,
                        6,
                      ),
                    ),
                  ],
                ),
                child: _buildAvatar(
                  size: 88,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.border,
                    ),
                  ),
                  child: const Icon(
                    Icons.edit_outlined,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            _displayName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            _email,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          OutlinedButton.icon(
            onPressed: _editProfile,
            icon: const Icon(
              Icons.edit_outlined,
            ),
            label: const Text(
              'Edit Profile',
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(
                color: AppColors.border,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityOverview() {
    if (_isLoading) {
      return Container(
        height: 125,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(
            22,
          ),
          border: Border.all(
            color: AppColors.border,
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      );
    }

    final summary = _securitySummary;

    if (summary == null) {
      return Container(
        padding: const EdgeInsets.all(
          18,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(
            22,
          ),
          border: Border.all(
            color: AppColors.border,
          ),
        ),
        child: const Text(
          'Security overview is currently unavailable.',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    final scoreColor = summary.score >= 80
        ? AppColors.safe
        : summary.score >= 50
            ? AppColors.suspicious
            : AppColors.highRisk;

    return GestureDetector(
      onTap: () {
        _openScreen(
          const SecurityActivityScreen(),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(
          18,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(
            22,
          ),
          border: Border.all(
            color: AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: scoreColor.withOpacity(
                  0.10,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shield_outlined,
                color: scoreColor,
                size: 29,
              ),
            ),
            const SizedBox(
              width: 14,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Security Overview',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    summary.status,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: scoreColor,
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    '${summary.activityCount} security checks recorded',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  '${summary.score}',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    color: scoreColor,
                  ),
                ),
                const Text(
                  'score',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 4,
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required String description,
    VoidCallback? onTap,
    bool showBadge = false,
  }) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(
        20,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          20,
        ),
        child: Container(
          padding: const EdgeInsets.all(
            16,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              20,
            ),
            border: Border.all(
              color: AppColors.border,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(
                    14,
                  ),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 23,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 12.5,
                        height: 1.35,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (showBadge)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.highRiskBackground,
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                  ),
                  child: Text(
                    '$_unreadNotifications',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.highRisk,
                    ),
                  ),
                ),
              const SizedBox(
                width: 6,
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(
    String title,
  ) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        color: AppColors.textSecondary,
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _loadProfileData,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            32,
          ),
          children: [
            _buildProfileHeader(),
            const SizedBox(
              height: 20,
            ),
            _buildSecurityOverview(),
            const SizedBox(
              height: 28,
            ),
            _buildSectionLabel(
              'YOUR SENTRI ACTIVITY',
            ),
            const SizedBox(
              height: 10,
            ),
            _buildProfileOption(
              icon: Icons.assignment_outlined,
              title: 'My Reports',
              description: 'View cybercrime reports you have submitted.',
              onTap: () {
                _openScreen(
                  const MyReportsScreen(),
                );
              },
            ),
            const SizedBox(
              height: 12,
            ),
            _buildProfileOption(
              icon: Icons.insights_outlined,
              title: 'Security Activity',
              description: 'Review your scam and phishing checks.',
              onTap: () {
                _openScreen(
                  const SecurityActivityScreen(),
                );
              },
            ),
            const SizedBox(
              height: 12,
            ),
            _buildProfileOption(
              icon: Icons.notifications_none_rounded,
              title: 'Notifications',
              description: 'Review security alerts from Sentri.',
              showBadge: _unreadNotifications > 0,
              onTap: () {
                _openScreen(
                  const NotificationsScreen(),
                );
              },
            ),
            const SizedBox(
              height: 28,
            ),
            _buildSectionLabel(
              'LEARNING',
            ),
            const SizedBox(
              height: 10,
            ),
            _buildProfileOption(
              icon: Icons.bookmark_outline_rounded,
              title: 'Saved Lessons',
              description: 'Access lessons you save for later.',
              onTap: () {
                _openScreen(
                  const SavedLessonsScreen(),
                );
              },
            ),
            const SizedBox(
              height: 12,
            ),
            _buildProfileOption(
              icon: Icons.school_outlined,
              title: 'Learning Progress',
              description: 'Track the security topics you have completed.',
              onTap: () {
                _openScreen(
                  const LearningProgressScreen(),
                );
              },
            ),
            const SizedBox(
              height: 28,
            ),
            _buildSectionLabel(
              'ACCOUNT',
            ),
            const SizedBox(
              height: 10,
            ),
            _buildProfileOption(
              icon: Icons.settings_outlined,
              title: 'Settings',
              description: 'Manage your Sentri preferences.',
              onTap: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  const SnackBar(
                    backgroundColor: AppColors.primary,
                    behavior: SnackBarBehavior.floating,
                    content: Text(
                      'Settings are coming next.',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
