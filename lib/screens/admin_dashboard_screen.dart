import 'package:flutter/material.dart';

import '../models/admin_models.dart';
import '../models/auth_response.dart';
import '../services/admin_api_service.dart';
import '../services/auth_api_service.dart';
import '../theme/app_colors.dart';

import 'admin_reports_screen.dart';
import 'admin_users_screen.dart';
import 'login_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  final AuthUser user;

  const AdminDashboardScreen({
    super.key,
    required this.user,
  });

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final AdminApiService _adminApiService = AdminApiService();

  AdminDashboardStats? _stats;

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final stats = await _adminApiService.getDashboardStats();

      if (!mounted) {
        return;
      }

      setState(() {
        _stats = stats;
        _isLoading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage = e.message;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage = 'Unable to load the administrator dashboard.';
      });
    }
  }

  Future<void> _logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Log out?',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          content: const Text(
            'You will need to log in again to access Sentri.',
            style: TextStyle(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.highRisk,
                foregroundColor: AppColors.white,
              ),
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true) {
      return;
    }

    await AuthApiService().logout();

    if (!mounted) {
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  Future<void> _openScreen(
    Widget screen,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );

    if (!mounted) {
      return;
    }

    await _loadDashboard();
  }

  String get _firstName {
    final name = widget.user.fullName.trim();

    if (name.isEmpty) {
      return 'Administrator';
    }

    return name.split(' ').first;
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        22,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(
                    0.12,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: AppColors.white.withOpacity(
                      0.15,
                    ),
                  ),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.admin_panel_settings_outlined,
                  color: AppColors.white,
                  size: 27,
                ),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Log out',
                onPressed: _logout,
                icon: const Icon(
                  Icons.logout_rounded,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Administrator Dashboard',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
              color: AppColors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            'Welcome back, $_firstName',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.white.withOpacity(
                0.78,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.user.email,
            style: TextStyle(
              fontSize: 12.5,
              color: AppColors.white.withOpacity(
                0.60,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
    String title,
  ) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w800,
        color: AppColors.textDark,
      ),
    );
  }

  Widget _buildMainStatCard({
    required String title,
    required int value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.white,
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
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
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
                  title,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.toString(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard({
    required String title,
    required int value,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 22,
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          ),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManagementCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.border,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 12.5,
                        height: 1.4,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardContent() {
    if (_isLoading && _stats == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(
          vertical: 70,
        ),
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      );
    }

    if (_errorMessage != null && _stats == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.highRiskBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.highRisk.withOpacity(
              0.18,
            ),
          ),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.highRisk,
              size: 30,
            ),
            const SizedBox(height: 10),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                height: 1.45,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 13),
            OutlinedButton(
              onPressed: _loadDashboard,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    final stats = _stats!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          'System Overview',
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = (constraints.maxWidth - 12) / 2;

            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: width,
                  child: _buildMainStatCard(
                    title: 'Total Users',
                    value: stats.totalUsers,
                    icon: Icons.people_outline_rounded,
                  ),
                ),
                SizedBox(
                  width: width,
                  child: _buildMainStatCard(
                    title: 'Total Reports',
                    value: stats.totalReports,
                    icon: Icons.assignment_outlined,
                  ),
                ),
                SizedBox(
                  width: width,
                  child: _buildMainStatCard(
                    title: 'Security Checks',
                    value: stats.totalSecurityChecks,
                    icon: Icons.shield_outlined,
                  ),
                ),
                SizedBox(
                  width: width,
                  child: _buildMainStatCard(
                    title: 'Pending Reports',
                    value: stats.pendingReports,
                    icon: Icons.pending_actions_outlined,
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 28),
        _buildSectionTitle(
          'Security Activity',
        ),
        const SizedBox(height: 12),
        _buildActivityCard(
          title: 'Scam Checks',
          value: stats.scamChecks,
          icon: Icons.security_rounded,
          iconColor: AppColors.primary,
          backgroundColor: AppColors.primaryLight,
        ),
        const SizedBox(height: 10),
        _buildActivityCard(
          title: 'Phishing Checks',
          value: stats.phishingChecks,
          icon: Icons.link_rounded,
          iconColor: AppColors.primary,
          backgroundColor: AppColors.primaryLight,
        ),
        const SizedBox(height: 10),
        _buildActivityCard(
          title: 'High Risk Flags',
          value: stats.highRiskChecks,
          icon: Icons.warning_amber_rounded,
          iconColor: AppColors.highRisk,
          backgroundColor: AppColors.highRiskBackground,
        ),
        const SizedBox(height: 10),
        _buildActivityCard(
          title: 'Suspicious Flags',
          value: stats.suspiciousChecks,
          icon: Icons.info_outline_rounded,
          iconColor: AppColors.suspicious,
          backgroundColor: AppColors.suspiciousBackground,
        ),
        const SizedBox(height: 28),
        _buildSectionTitle(
          'Management',
        ),
        const SizedBox(height: 12),
        _buildManagementCard(
          icon: Icons.assignment_outlined,
          title: 'Manage Reports',
          description:
              'Review submitted cybercrime reports and update their status.',
          onTap: () {
            _openScreen(
              const AdminReportsScreen(),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildManagementCard(
          icon: Icons.people_outline_rounded,
          title: 'Manage Users',
          description: 'View registered Sentri users and account roles.',
          onTap: () {
            _openScreen(
              const AdminUsersScreen(),
            );
          },
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: AppColors.primary,
                size: 21,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'The administrator dashboard provides a centralized view of Sentri activity, reports and registered users.',
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.5,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: _loadDashboard,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              20,
              18,
              20,
              32,
            ),
            children: [
              _buildHeader(),
              const SizedBox(height: 22),
              _buildDashboardContent(),
            ],
          ),
        ),
      ),
    );
  }
}
