import 'package:flutter/material.dart';

import '../models/analysis_result.dart';
import '../services/auth_api_service.dart';
import '../services/phishing_analysis_service.dart';
import '../services/security_recommendation_service.dart';
import '../theme/app_colors.dart';
import '../widgets/phishing_result_card.dart';
import '../widgets/security_recommendation_card.dart';

class PhishingCheckScreen extends StatefulWidget {
  const PhishingCheckScreen({
    super.key,
  });

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
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final url = _urlController.text.trim();

    setState(() {
      _isLoading = true;
      _analysisResult = null;
      _recommendation = null;
    });

    try {
      final result = await _phishingAnalysisService.analyze(
        url,
      );

      if (!mounted) {
        return;
      }

      final recommendation = _recommendationService.forPhishing(
        result,
        url: url,
      );

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
          content: Text(e.message),
        ),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
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

  void _resetScan() {
    FocusScope.of(context).unfocus();

    setState(() {
      _urlController.clear();
      _analysisResult = null;
      _recommendation = null;
    });
  }

  Widget _buildResultSection() {
    final result = _analysisResult;

    if (result == null) {
      return const SizedBox.shrink();
    }

    return AnimatedSwitcher(
      duration: const Duration(
        milliseconds: 350,
      ),
      switchInCurve: Curves.easeOutCubic,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.04),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: Column(
        key: ValueKey(
          '${result.riskLevel}-${result.riskScore}-${result.message}',
        ),
        children: [
          PhishingResultCard(
            result: result,
          ),
          if (_recommendation != null) ...[
            const SizedBox(height: 16),
            SecurityRecommendationCard(
              recommendation: _recommendation!,
            ),
          ],
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: _resetScan,
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label: const Text(
                'Check another link',
              ),
            ),
          ),
        ],
      ),
    );
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
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            32,
          ),
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

            const SizedBox(height: 9),

            const Text(
              'Paste a link below and Sentri will assess its risk '
              'and explain the indicators it found.',
              style: TextStyle(
                fontSize: 15.5,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Link',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),

            const SizedBox(height: 10),

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
                  textInputAction: TextInputAction.done,
                  enabled: !_isLoading,
                  autocorrect: false,
                  onFieldSubmitted: (_) {
                    if (!_isLoading) {
                      _analyzeLink();
                    }
                  },
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Suspicious link',
                    hintText: 'https://example.com',
                    labelStyle: const TextStyle(
                      color: AppColors.textSecondary,
                    ),
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
                    final text = value?.trim() ?? '';

                    if (text.isEmpty) {
                      return 'Please enter a URL';
                    }

                    final uri = Uri.tryParse(text);

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
                      'of the URL. Never enter passwords, PINs, OTPs, '
                      'or other sensitive information while investigating a suspicious link.',
                      style: TextStyle(
                        fontSize: 12.5,
                        height: 1.45,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --------------------------------------------------
            // Analyze button
            // --------------------------------------------------
            SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _analyzeLink,
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
                            Icons.link_rounded,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Check Link',
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
              const SizedBox(height: 26),
              _buildResultSection(),
            ],
          ],
        ),
      ),
    );
  }
}
