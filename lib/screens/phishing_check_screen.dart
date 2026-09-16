import 'package:flutter/material.dart';

import '../models/analysis_result.dart';

import '../services/auth_api_service.dart';
import '../services/phishing_analysis_service.dart';
import '../services/security_recommendation_service.dart';

import '../theme/app_colors.dart';

import '../widgets/phishing_result_card.dart';
import '../widgets/security_recommendation_card.dart';

class PhishingCheckScreen extends StatefulWidget {
  const PhishingCheckScreen({super.key});

  @override
  State<PhishingCheckScreen> createState() => _PhishingCheckScreenState();
}

class _PhishingCheckScreenState extends State<PhishingCheckScreen> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();

  final PhishingAnalysisService _phishingAnalysisService =
      PhishingAnalysisService();
  final SecurityRecommendationService _recommendationService =
      const SecurityRecommendationService();

  bool _isLoading = false;
  AnalysisResult? _analysisResult;
  SecurityRecommendation? _recommendation;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _analyzeLink() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _analysisResult = null;
    });

    try {
      final result = await _phishingAnalysisService.analyze(
        _urlController.text.trim(),
      );

      if (!mounted) {
        return;
      }

      final recommendation = _recommendationService.forPhishing(result);

      setState(() {
        _analysisResult = result;
        _recommendation = recommendation;
      });
    } on ApiException catch (e) {
      if (!mounted) {
        return;
      }

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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.highRisk,
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Something went wrong. Please try again.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Phishing Check',
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
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [
            // --------------------------------------------------
            // Header
            // --------------------------------------------------
            const Text(
              'Check a suspicious link',
              style: TextStyle(
                fontSize: 29,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
                height: 1.15,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Paste a link below and Sentri will help you assess '
              'whether it may be a phishing link.',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 24),

            // --------------------------------------------------
            // URL input
            // --------------------------------------------------
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.border,
                ),
              ),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: _urlController,
                  keyboardType: TextInputType.url,
                  enabled: !_isLoading,
                  autocorrect: false,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Suspicious link',
                    labelStyle: const TextStyle(
                      color: AppColors.textSecondary,
                    ),
                    hintText: 'https://example.com',
                    hintStyle: TextStyle(
                      color: AppColors.textSecondary.withOpacity(0.75),
                    ),
                    prefixIcon: const Icon(
                      Icons.link_outlined,
                      color: AppColors.primary,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a URL';
                    }

                    final uri = Uri.tryParse(value.trim());

                    if (uri == null ||
                        (uri.scheme != 'http' && uri.scheme != 'https') ||
                        uri.host.isEmpty) {
                      return 'Enter a valid URL';
                    }

                    return null;
                  },
                ),
              ),
            ),

            const SizedBox(height: 14),

            // --------------------------------------------------
            // Safety note
            // --------------------------------------------------
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.15),
                ),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Sentri checks the structure and characteristics '
                      'of the URL. Avoid entering sensitive information '
                      'while you verify suspicious links.',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.45,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // --------------------------------------------------
            // Analyze button
            // --------------------------------------------------
            SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _analyzeLink,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  disabledBackgroundColor: AppColors.primary.withOpacity(0.45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 21,
                        width: 21,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          color: AppColors.white,
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shield_outlined,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Analyze Link',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            // --------------------------------------------------
            // Result
            // --------------------------------------------------
            if (_analysisResult != null) ...[
              const SizedBox(height: 28),
              PhishingResultCard(
                result: _analysisResult!,
              ),
              if (_recommendation != null) ...[
                const SizedBox(height: 16),
                SecurityRecommendationCard(
                  recommendation: _recommendation!,
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
