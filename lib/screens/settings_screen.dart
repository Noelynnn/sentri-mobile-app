import 'package:flutter/material.dart';

import '../models/auth_response.dart';
import '../services/auth_api_service.dart';
import '../theme/app_colors.dart';
import 'edit_profile_screen.dart';
import 'login_screen.dart';
import 'notifications_screen.dart';
import 'security_activity_screen.dart';

class SettingsScreen extends StatefulWidget {
  final AuthUser user;

  const SettingsScreen({
    super.key,
    required this.user,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late AuthUser _user;

  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  Future<void> _editProfile() async {
    final updatedUser = await Navigator.push<AuthUser>(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(
          user: _user,
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

  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Log Out',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          content: const Text(
            'Are you sure you want to log out of Sentri?',
            style: TextStyle(
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.highRisk,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Log Out',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true) {
      return;
    }

    await _logout();
  }

  Future<void> _logout() async {
    setState(() {
      _isLoggingOut = true;
    });

    try {
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
    } on ApiException catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoggingOut = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.highRisk,
          behavior: SnackBarBehavior.floating,
          content: Text(e.message),
        ),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoggingOut = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.highRisk,
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Unable to log out. Please try again.',
          ),
        ),
      );
    }
  }

  void _showAboutSentri() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'About Sentri',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          content: const Text(
            'Sentri is your digital safety companion, '
            'designed to help you identify scams, check '
            'suspicious messages and links, learn cybersecurity, '
            'and report cybercrime.',
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Close',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 4,
        bottom: 10,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: AppColors.textSecondary,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    final color = iconColor ?? AppColors.primary;

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: _isLoggingOut ? null : onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
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
                  color: color.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 23,
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
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
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

  Widget _buildAccountSummary() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              _initials,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _user.fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _user.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
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

  String get _initials {
    final name = _user.fullName.trim();

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
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }

    return parts.first[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Settings',
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
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            32,
          ),
          children: [
            _buildAccountSummary(),
            const SizedBox(height: 28),
            _buildSectionLabel(
              'ACCOUNT',
            ),
            _buildSettingTile(
              icon: Icons.person_outline_rounded,
              title: 'Edit Profile',
              description: 'Change your name or profile picture.',
              onTap: _editProfile,
            ),
            const SizedBox(height: 12),
            _buildSettingTile(
              icon: Icons.email_outlined,
              title: 'Email Address',
              description: _user.email,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: AppColors.primary,
                    behavior: SnackBarBehavior.floating,
                    content: Text(
                      'Your email address is currently read-only.',
                    ),
                  ),
                );
              },
              iconColor: AppColors.textSecondary,
            ),
            const SizedBox(height: 28),
            _buildSectionLabel(
              'SECURITY',
            ),
            _buildSettingTile(
              icon: Icons.insights_outlined,
              title: 'Security Activity',
              description: 'Review your scam and phishing checks.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SecurityActivityScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildSettingTile(
              icon: Icons.notifications_none_rounded,
              title: 'Notifications',
              description: 'Review security alerts from Sentri.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificationsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 28),
            _buildSectionLabel(
              'ABOUT',
            ),
            _buildSettingTile(
              icon: Icons.info_outline_rounded,
              title: 'About Sentri',
              description: 'Learn more about your digital safety companion.',
              onTap: _showAboutSentri,
            ),
            const SizedBox(height: 28),
            _buildSectionLabel(
              'ACCOUNT ACTIONS',
            ),
            Material(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                onTap: _isLoggingOut ? null : _confirmLogout,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.highRisk.withOpacity(0.20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: AppColors.highRiskBackground,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.logout_rounded,
                          color: AppColors.highRisk,
                          size: 23,
                        ),
                      ),
                      const SizedBox(width: 13),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Log Out',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.highRisk,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Sign out of your Sentri account.',
                              style: TextStyle(
                                fontSize: 12.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_isLoggingOut)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.highRisk,
                          ),
                        )
                      else
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: AppColors.textSecondary,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
