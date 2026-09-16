import 'package:flutter/material.dart';

import '../config/api_config.dart';
import '../models/report.dart';
import '../services/report_api_service.dart';
import '../services/security_activity_service.dart';
import '../services/notification_service.dart';
import '../services/profile_api_service.dart';
import '../theme/app_colors.dart';
import '../widgets/quick_action_card.dart';
import '../widgets/security_status_card.dart';

import 'check_scam_screen.dart';
import 'phishing_check_screen.dart';
import 'learn_security_screen.dart';
import 'report_crime_screen.dart';
import 'my_reports_screen.dart';
import 'security_activity_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;

  const HomeScreen({
    super.key,
    required this.userName,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ReportApiService _reportApiService = ReportApiService();

  final SecurityActivityService _securityActivityService =
      SecurityActivityService();

  final NotificationService _notificationService = NotificationService();

  final ProfileApiService _profileService = ProfileApiService();

  List<Report> _recentReports = [];

  bool _reportsLoading = true;

  SecurityActivitySummary? _securitySummary;

  bool _securityLoading = true;

  int _unreadNotificationCount = 0;

  String? _profileImagePath;

  final List<String> _cyberTips = [
    'Never share your OTP, PIN, or password with anyone.',
    'Verify unexpected messages before clicking links.',
    'Use two-factor authentication on important accounts.',
    'Avoid sending money when a message creates unnecessary urgency.',
    'Keep your phone and apps updated to reduce security risks.',
    'Check the sender carefully before trusting a message.',
    'Use different passwords for your most important accounts.',
  ];

  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  String? _profileImageUrl() {
    if (_profileImagePath == null || _profileImagePath!.isEmpty) {
      return null;
    }

    if (_profileImagePath!.startsWith('http://') ||
        _profileImagePath!.startsWith('https://')) {
      return _profileImagePath;
    }

    return '${ApiConfig.baseUrl}/'
        '${_profileImagePath!.replaceFirst('/', '')}';
  }

  Future<void> _loadHomeData() async {
    await Future.wait([
      _loadRecentReports(),
      _loadSecuritySummary(),
      _loadUnreadNotifications(),
    ]);

    _loadProfileImage();
  }

  Future<void> _loadRecentReports() async {
    try {
      final reports = await _reportApiService.getReports();

      if (!mounted) return;

      setState(() {
        _recentReports = reports.take(3).toList();
        _reportsLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _recentReports = [];
        _reportsLoading = false;
      });
    }
  }

  Future<void> _loadSecuritySummary() async {
    try {
      final summary = await _securityActivityService.getSummary();

      if (!mounted) return;

      setState(() {
        _securitySummary = summary;
        _securityLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _securitySummary = null;
        _securityLoading = false;
      });
    }
  }

  Future<void> _loadUnreadNotifications() async {
    try {
      final count = await _notificationService.getUnreadCount();

      if (!mounted) return;

      setState(() {
        _unreadNotificationCount = count;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _unreadNotificationCount = 0;
      });
    }
  }

  Future<void> _loadProfileImage() async {
    try {
      final profile = await _profileService.getProfile();

      if (!mounted) return;

      setState(() {
        _profileImagePath = profile['profile_image_path'] as String?;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _profileImagePath = null;
      });
    }
  }

  Future<void> _refreshHome() async {
    await _loadHomeData();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good morning';
    }

    if (hour < 17) {
      return 'Good afternoon';
    }

    return 'Good evening';
  }

  String get _firstName {
    final trimmedName = widget.userName.trim();

    if (trimmedName.isEmpty) {
      return 'there';
    }

    return trimmedName.split(' ').first;
  }

  String get _firstLetter {
    final name = _firstName.trim();

    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  String get _cyberTip {
    final day = DateTime.now().day;

    return _cyberTips[day % _cyberTips.length];
  }

  void _openScreen(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    ).then((_) {
      if (!mounted) return;

      _loadHomeData();
    });
  }

  Widget _buildHomeAvatar() {
    final imageUrl = _profileImageUrl();

    if (imageUrl == null) {
      return Text(
        _firstLetter,
        style: const TextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.w800,
          fontSize: 16,
        ),
      );
    }

    return ClipOval(
      child: Image.network(
        imageUrl,
        width: 44,
        height: 44,
        fit: BoxFit.cover,
        loadingBuilder: (
          context,
          child,
          loadingProgress,
        ) {
          if (loadingProgress == null) {
            return child;
          }

          return Text(
            _firstLetter,
            style: const TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Text(
            _firstLetter,
            style: const TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        18,
        16,
        14,
        16,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_getGreeting()}, $_firstName 👋',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Stay one step ahead of online threats.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.35,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            tooltip: 'Notifications',
            onPressed: () {
              _openScreen(
                const NotificationsScreen(),
              );
            },
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(
                  Icons.notifications_none_rounded,
                  size: 27,
                  color: AppColors.textDark,
                ),
                if (_unreadNotificationCount > 0)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      constraints: const BoxConstraints(
                        minWidth: 9,
                        minHeight: 9,
                      ),
                      padding: _unreadNotificationCount > 9
                          ? const EdgeInsets.symmetric(
                              horizontal: 3,
                            )
                          : EdgeInsets.zero,
                      decoration: BoxDecoration(
                        color: AppColors.highRisk,
                        borderRadius: BorderRadius.circular(
                          20,
                        ),
                        border: Border.all(
                          color: AppColors.white,
                          width: 1.5,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: _unreadNotificationCount > 9
                          ? Text(
                              _unreadNotificationCount > 99
                                  ? '99+'
                                  : '$_unreadNotificationCount',
                              style: const TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w800,
                                color: AppColors.white,
                              ),
                            )
                          : const SizedBox(
                              width: 5,
                              height: 5,
                            ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 2),
          GestureDetector(
            onTap: () {
              _openScreen(
                ProfileScreen(
                  userName: widget.userName,
                ),
              );
            },
            child: Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: _buildHomeAvatar(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityStatus() {
    if (_securityLoading) {
      return Container(
        width: double.infinity,
        height: 220,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
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

    if (_securitySummary == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.refresh_rounded,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Security activity is currently unavailable. Pull down to refresh.',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.45,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final summary = _securitySummary!;

    return GestureDetector(
      onTap: () {
        _openScreen(
          const SecurityActivityScreen(),
        );
      },
      child: SecurityStatusCard(
        status: summary.status,
        message: summary.message,
        activityCount: summary.activityCount,
        recentSuspiciousCount: summary.recentSuspiciousCount,
        recentHighRiskCount: summary.recentHighRiskCount,
      ),
    );
  }

  Widget _buildQuickScanButton() {
    return Material(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: () {
          _openScreen(
            const CheckScamScreen(),
          );
        },
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.18),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(
                    17,
                  ),
                ),
                child: const Icon(
                  Icons.radar_rounded,
                  color: AppColors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 15),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Scan',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Check a suspicious message, screenshot, or link.',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColors.white,
                    size: 22,
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Scan',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle({
    required String title,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              actionLabel,
            ),
          ),
      ],
    );
  }

  Widget _buildSafetyReminder() {
    return Material(
      color: AppColors.primaryLight,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () {
          _openScreen(
            const LearnSecurityScreen(),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.14),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(
                    14,
                  ),
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Safety Reminder',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Never share your OTP, PIN, or password, even when someone claims to represent a trusted company.',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 9),
                    Text(
                      'Learn more →',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
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

  Widget _buildCyberTip() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.lightbulb_outline_rounded,
              color: AppColors.primary,
              size: 23,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cyber Tip of the Day',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _cyberTip,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.5,
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

  Widget _buildRecentReports() {
    if (_reportsLoading) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
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

    if (_recentReports.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.border,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.assignment_outlined,
                color: AppColors.primary,
                size: 26,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'No reports yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Reports you submit through Sentri will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 14),
            TextButton(
              onPressed: () {
                _openScreen(
                  const ReportCrimeScreen(),
                );
              },
              child: const Text(
                'Create a report',
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: _recentReports.map(
        (report) {
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.only(
              bottom: 12,
            ),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(
                20,
              ),
              border: Border.all(
                color: AppColors.border,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  child: const Icon(
                    Icons.report_gmailerrorred_outlined,
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
                        report.incidentType,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        report.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(
                        height: 9,
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              report.referenceNumber,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.safeBackground,
                              borderRadius: BorderRadius.circular(
                                20,
                              ),
                            ),
                            child: Text(
                              report.status,
                              style: const TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.safe,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ).toList(),
    );
  }

  Widget _buildContinueLearning() {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () {
          _openScreen(
            const LearnSecurityScreen(),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.border,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(
                    14,
                  ),
                ),
                child: const Icon(
                  Icons.school_outlined,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Continue Learning',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      'Build practical digital safety skills.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_rounded,
                size: 18,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: _refreshHome,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              20,
              14,
              20,
              32,
            ),
            children: [
              _buildHeader(),
              const SizedBox(
                height: 20,
              ),
              _buildSecurityStatus(),
              const SizedBox(
                height: 18,
              ),
              _buildQuickScanButton(),
              const SizedBox(
                height: 28,
              ),
              _buildSectionTitle(
                title: 'Quick Actions',
              ),
              const SizedBox(
                height: 12,
              ),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: QuickActionCard(
                        title: 'Check Scam',
                        description: 'Analyze a message or screenshot.',
                        icon: Icons.security_rounded,
                        onTap: () {
                          _openScreen(
                            const CheckScamScreen(),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: QuickActionCard(
                        title: 'Phishing Check',
                        description: 'Check whether a link may be dangerous.',
                        icon: Icons.link_rounded,
                        onTap: () {
                          _openScreen(
                            const PhishingCheckScreen(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: QuickActionCard(
                        title: 'Learn Security',
                        description: 'Build practical digital safety skills.',
                        icon: Icons.school_outlined,
                        onTap: () {
                          _openScreen(
                            const LearnSecurityScreen(),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: QuickActionCard(
                        title: 'Report Crime',
                        description: 'Document and report a cybercrime.',
                        icon: Icons.report_outlined,
                        onTap: () {
                          _openScreen(
                            const ReportCrimeScreen(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 28,
              ),
              _buildSectionTitle(
                title: 'Safety Reminder',
              ),
              const SizedBox(
                height: 12,
              ),
              _buildSafetyReminder(),
              const SizedBox(
                height: 28,
              ),
              _buildSectionTitle(
                title: 'Cyber Tip of the Day',
              ),
              const SizedBox(
                height: 12,
              ),
              _buildCyberTip(),
              const SizedBox(
                height: 28,
              ),
              _buildSectionTitle(
                title: 'Recent Reports',
                actionLabel: 'View All',
                onAction: () {
                  _openScreen(
                    const MyReportsScreen(),
                  );
                },
              ),
              const SizedBox(
                height: 12,
              ),
              _buildRecentReports(),
              const SizedBox(
                height: 16,
              ),
              _buildContinueLearning(),
            ],
          ),
        ),
      ),
    );
  }
}
