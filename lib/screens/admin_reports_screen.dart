import 'package:flutter/material.dart';

import '../models/admin_models.dart';
import '../services/admin_api_service.dart';
import '../services/auth_api_service.dart';
import '../theme/app_colors.dart';

class AdminReportsScreen extends StatefulWidget {
  const AdminReportsScreen({
    super.key,
  });

  @override
  State<AdminReportsScreen> createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends State<AdminReportsScreen> {
  final AdminApiService _adminApiService = AdminApiService();

  List<AdminReport> _reports = [];

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final reports = await _adminApiService.getReports();

      if (!mounted) {
        return;
      }

      setState(() {
        _reports = reports;
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
        _errorMessage = 'Unable to load submitted reports.';
      });
    }
  }

  Future<void> _updateStatus(
    AdminReport report,
    String newStatus,
  ) async {
    final oldStatus = report.status;

    setState(() {
      _reports = _reports.map((item) {
        if (item.id == report.id) {
          return item.copyWith(
            status: newStatus,
          );
        }

        return item;
      }).toList();
    });

    try {
      await _adminApiService.updateReportStatus(
        reportId: report.id,
        status: newStatus,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.safe,
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Report ${report.referenceNumber} updated to '
            '${_formatStatus(newStatus)}.',
          ),
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _reports = _reports.map((item) {
          if (item.id == report.id) {
            return item.copyWith(
              status: oldStatus,
            );
          }

          return item;
        }).toList();
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
        _reports = _reports.map((item) {
          if (item.id == report.id) {
            return item.copyWith(
              status: oldStatus,
            );
          }

          return item;
        }).toList();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.highRisk,
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Unable to update the report status.',
          ),
        ),
      );
    }
  }

  Future<void> _showReportDetails(
    AdminReport report,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _ReportDetailsSheet(
          report: report,
          onStatusChanged: (status) {
            Navigator.pop(context);
            _updateStatus(report, status);
          },
        );
      },
    );

    if (!mounted) {
      return;
    }

    await _loadReports();
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Manage Reports',
          style: TextStyle(
            fontSize: 29,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
            height: 1.15,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Review submitted cybercrime reports and '
          'keep their status up to date.',
          style: TextStyle(
            fontSize: 15,
            height: 1.5,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryBar() {
    final pending = _reports
        .where(
          (report) => report.status == 'submitted',
        )
        .length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.assignment_outlined,
            color: AppColors.primary,
            size: 24,
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              '${_reports.length} total report'
              '${_reports.length == 1 ? '' : 's'}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$pending pending',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(
    AdminReport report,
  ) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () {
          _showReportDetails(report);
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.border,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.report_gmailerrorred_outlined,
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
                          report.incidentType,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          report.referenceNumber,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _StatusChip(
                    status: report.status,
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                report.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13.5,
                  height: 1.45,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 13),
              Row(
                children: [
                  const Icon(
                    Icons.person_outline_rounded,
                    size: 17,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      report.userName,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.photo_library_outlined,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${report.evidenceCount}',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Row(
                children: [
                  Icon(
                    Icons.touch_app_outlined,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Tap to view details',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _reports.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(
          vertical: 80,
        ),
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      );
    }

    if (_errorMessage != null && _reports.isEmpty) {
      return Container(
        width: double.infinity,
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
              onPressed: _loadReports,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (_reports.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 38,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.border,
          ),
        ),
        child: const Column(
          children: [
            Icon(
              Icons.assignment_turned_in_outlined,
              color: AppColors.primary,
              size: 42,
            ),
            SizedBox(height: 14),
            Text(
              'No reports submitted yet',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            SizedBox(height: 7),
            Text(
              'Submitted cybercrime reports will appear '
              'here for administrator review.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: _reports
          .map(
            _buildReportCard,
          )
          .toList(),
    );
  }

  String _formatStatus(
    String status,
  ) {
    switch (status.toLowerCase()) {
      case 'submitted':
        return 'Submitted';
      case 'reviewed':
        return 'Reviewed';
      case 'under_review':
        return 'Under Review';
      case 'resolved':
        return 'Resolved';
      default:
        return status
            .replaceAll('_', ' ')
            .split(' ')
            .map(
              (word) => word.isEmpty
                  ? word
                  : '${word[0].toUpperCase()}'
                      '${word.substring(1)}',
            )
            .join(' ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Reports',
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
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: _loadReports,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              20,
              12,
              20,
              32,
            ),
            children: [
              _buildHeader(),
              const SizedBox(height: 22),
              if (!_isLoading) _buildSummaryBar(),
              const SizedBox(height: 18),
              _buildBody(),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'submitted':
        backgroundColor = AppColors.suspiciousBackground;
        textColor = AppColors.suspicious;
        break;

      case 'under_review':
      case 'reviewed':
        backgroundColor = AppColors.primaryLight;
        textColor = AppColors.primary;
        break;

      case 'resolved':
        backgroundColor = AppColors.safeBackground;
        textColor = AppColors.safe;
        break;

      default:
        backgroundColor = AppColors.primaryLight;
        textColor = AppColors.primary;
    }

    final label = status
        .replaceAll('_', ' ')
        .split(' ')
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}'
                  '${word.substring(1)}',
        )
        .join(' ');

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w800,
          color: textColor,
        ),
      ),
    );
  }
}

class _ReportDetailsSheet extends StatelessWidget {
  final AdminReport report;
  final ValueChanged<String> onStatusChanged;

  const _ReportDetailsSheet({
    required this.report,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            28,
          ),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.description_outlined,
                    color: AppColors.primary,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 13),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Report Details',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Administrator review',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            _DetailCard(
              children: [
                _DetailRow(
                  label: 'Reference',
                  value: report.referenceNumber,
                  icon: Icons.tag_outlined,
                ),
                _DetailRow(
                  label: 'Incident',
                  value: report.incidentType,
                  icon: Icons.report_outlined,
                ),
                _DetailRow(
                  label: 'Submitted by',
                  value: report.userName,
                  icon: Icons.person_outline,
                ),
                _DetailRow(
                  label: 'Email',
                  value: report.userEmail,
                  icon: Icons.email_outlined,
                ),
                _DetailRow(
                  label: 'Evidence',
                  value: report.evidenceCount == 0
                      ? 'None attached'
                      : '${report.evidenceCount} image'
                          '${report.evidenceCount == 1 ? '' : 's'}',
                  icon: Icons.photo_library_outlined,
                ),
                _DetailRow(
                  label: 'Submitted',
                  value: _formatDate(report.createdAt),
                  icon: Icons.schedule_outlined,
                  isLast: true,
                ),
              ],
            ),
            const SizedBox(height: 14),
            _DetailCard(
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                Text(
                  report.description,
                  style: const TextStyle(
                    fontSize: 13.5,
                    height: 1.55,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (report.additionalDetails != null &&
                    report.additionalDetails!.trim().isNotEmpty) ...[
                  const SizedBox(height: 18),
                  const Text(
                    'Additional Details',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    report.additionalDetails!,
                    style: const TextStyle(
                      fontSize: 13.5,
                      height: 1.55,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 22),
            const Text(
              'Update report status',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 11),
            _StatusOption(
              label: 'Submitted',
              value: 'submitted',
              currentValue: report.status,
              icon: Icons.assignment_outlined,
              onTap: () {
                onStatusChanged('submitted');
              },
            ),
            const SizedBox(height: 9),
            _StatusOption(
              label: 'Under Review',
              value: 'under_review',
              currentValue: report.status,
              icon: Icons.manage_search_outlined,
              onTap: () {
                onStatusChanged('under_review');
              },
            ),
            const SizedBox(height: 9),
            _StatusOption(
              label: 'Reviewed',
              value: 'reviewed',
              currentValue: report.status,
              icon: Icons.fact_check_outlined,
              onTap: () {
                onStatusChanged('reviewed');
              },
            ),
            const SizedBox(height: 9),
            _StatusOption(
              label: 'Resolved',
              value: 'resolved',
              currentValue: report.status,
              icon: Icons.check_circle_outline,
              onTap: () {
                onStatusChanged('resolved');
              },
            ),
          ],
        ),
      ),
    );
  }

  static String _formatDate(String value) {
    try {
      final parsed = DateTime.parse(value).toLocal();

      final day = parsed.day.toString().padLeft(2, '0');
      final month = parsed.month.toString().padLeft(2, '0');
      final year = parsed.year.toString();

      final hour = parsed.hour.toString().padLeft(2, '0');
      final minute = parsed.minute.toString().padLeft(2, '0');

      return '$day/$month/$year at '
          '$hour:$minute';
    } catch (_) {
      return value;
    }
  }
}

class _DetailCard extends StatelessWidget {
  final List<Widget> children;

  const _DetailCard({
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isLast;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.icon,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: isLast ? 0 : 14,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: AppColors.primary,
          ),
          const SizedBox(width: 9),
          SizedBox(
            width: 86,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusOption extends StatelessWidget {
  final String label;
  final String value;
  final String currentValue;
  final IconData icon;
  final VoidCallback onTap;

  const _StatusOption({
    required this.label,
    required this.value,
    required this.currentValue,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selected = value == currentValue;

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: selected ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 13,
          ),
          decoration: BoxDecoration(
            color: selected ? AppColors.primaryLight : AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 21,
                color: selected ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: selected ? AppColors.primary : AppColors.textDark,
                  ),
                ),
              ),
              Icon(
                selected
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked,
                size: 21,
                color: selected ? AppColors.primary : AppColors.border,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
