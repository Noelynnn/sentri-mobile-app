import 'package:flutter/material.dart';

import '../data/safety_actions.dart';
import '../models/safety_action.dart';
import '../theme/app_colors.dart';

class ActionCenterScreen extends StatefulWidget {
  final String riskLevel;
  final String analysisType;

  /// Optional callbacks allow the detection result screen to connect
  /// the Action Center to reporting and learning.
  final VoidCallback? onReportIncident;
  final VoidCallback? onLearnMore;

  const ActionCenterScreen({
    super.key,
    required this.riskLevel,
    required this.analysisType,
    this.onReportIncident,
    this.onLearnMore,
  });

  @override
  State<ActionCenterScreen> createState() => _ActionCenterScreenState();
}

class _ActionCenterScreenState extends State<ActionCenterScreen> {
  String _selectedInteraction = SafetyActions.interactionOptions.first;

  SafetyActionPlan get _currentPlan {
    return SafetyActions.getPlan(
      riskLevel: widget.riskLevel,
      interaction: _selectedInteraction,
      analysisType: widget.analysisType,
    );
  }

  bool get _isHighRisk {
    return widget.riskLevel.toLowerCase().trim() == 'highrisk';
  }

  bool get _isSuspicious {
    return widget.riskLevel.toLowerCase().trim() == 'suspicious';
  }

  String get _riskLabel {
    if (_isHighRisk) {
      return 'High Risk';
    }

    if (_isSuspicious) {
      return 'Suspicious';
    }

    return 'Clear';
  }

  Color get _riskColor {
    if (_isHighRisk) {
      return AppColors.highRisk;
    }

    if (_isSuspicious) {
      return AppColors.suspicious;
    }

    return AppColors.safe;
  }

  Color get _riskBackground {
    if (_isHighRisk) {
      return AppColors.highRiskBackground;
    }

    if (_isSuspicious) {
      return AppColors.suspiciousBackground;
    }

    return AppColors.safeBackground;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Action Center'),
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: [
              _buildIntroCard(),
              const SizedBox(height: 20),
              _buildSituationSection(),
              const SizedBox(height: 20),
              _buildPlanSection(),
              const SizedBox(height: 20),
              _buildBottomActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntroCard() {
    final normalizedType = widget.analysisType.toLowerCase().trim();

    final String threatType =
        normalizedType == 'phishing' ? 'Phishing check' : 'Scam check';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
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
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _riskBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.shield_outlined,
                  color: _riskColor,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'What should I do now?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      threatType,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: _riskBackground,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _riskColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _riskLabel,
                  style: TextStyle(
                    color: _riskColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            _isHighRisk
                ? 'Take the next steps carefully and avoid further interaction until you have secured yourself.'
                : _isSuspicious
                    ? 'A few warning signs were detected. Your next action matters, so take a moment to verify what happened.'
                    : 'Use these safety steps to continue protecting your accounts, money, and personal information.',
            style: const TextStyle(
              fontSize: 14,
              height: 1.55,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSituationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What happened?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Choose the option that best describes what you did after receiving the content.',
          style: TextStyle(
            fontSize: 13,
            height: 1.5,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: SafetyActions.interactionOptions.map((option) {
            final isSelected = option == _selectedInteraction;

            return ChoiceChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  _selectedInteraction = option;
                });
              },
              selectedColor: AppColors.primaryLight,
              backgroundColor: AppColors.white,
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.border,
              ),
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textDark,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 13,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPlanSection() {
    final plan = _currentPlan;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your safety plan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                plan.title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                plan.summary,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.55,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        ...plan.actions.asMap().entries.map(
              (entry) => _buildActionCard(
                entry.key + 1,
                entry.value,
              ),
            ),
      ],
    );
  }

  Widget _buildActionCard(
    int stepNumber,
    SafetyAction action,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: action.important
              ? _riskColor.withOpacity(0.35)
              : AppColors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color:
                  action.important ? _riskBackground : AppColors.primaryLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              action.icon,
              color: action.important ? _riskColor : AppColors.primary,
              size: 21,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        action.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$stepNumber',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  action.description,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (action.important) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.priority_high_rounded,
                        size: 15,
                        color: _riskColor,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Important',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: _riskColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Column(
      children: [
        if (widget.onReportIncident != null)
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: widget.onReportIncident,
              icon: const Icon(Icons.report_problem_outlined),
              label: const Text('Report Incident'),
            ),
          ),
        if (widget.onReportIncident != null && widget.onLearnMore != null)
          const SizedBox(height: 10),
        if (widget.onLearnMore != null)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: widget.onLearnMore,
              icon: const Icon(Icons.school_outlined),
              label: const Text('Learn More'),
            ),
          ),
        if (widget.onReportIncident != null || widget.onLearnMore != null)
          const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ),
      ],
    );
  }
}
