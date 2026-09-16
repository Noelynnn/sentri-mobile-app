import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/analysis_result.dart';

import '../services/auth_api_service.dart';
import '../services/scam_analysis_service.dart';
import '../services/security_recommendation_service.dart';

import '../theme/app_colors.dart';

import '../widgets/scam_result_card.dart';
import '../widgets/security_recommendation_card.dart';

class CheckScamScreen extends StatefulWidget {
  const CheckScamScreen({super.key});

  @override
  State<CheckScamScreen> createState() => _CheckScamScreenState();
}

class _CheckScamScreenState extends State<CheckScamScreen> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();

  final ScamAnalysisService _scamAnalysisService = ScamAnalysisService();
  final SecurityRecommendationService _recommendationService =
      const SecurityRecommendationService();

  final ImagePicker _picker = ImagePicker();

  bool _isLoading = false;
  XFile? _selectedImage;
  AnalysisResult? _analysisResult;
  SecurityRecommendation? _recommendation;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (!context.mounted) {
      return;
    }

    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<void> _analyzeScam() async {
    final message = _messageController.text.trim();

    final hasMessage = message.isNotEmpty;
    final hasImage = _selectedImage != null;

    if (!hasMessage && !hasImage) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.highRisk,
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Please enter a message or upload a screenshot.',
          ),
        ),
      );

      return;
    }

    setState(() {
      _isLoading = true;
      _analysisResult = null;
    });

    try {
      late final AnalysisResult result;

      if (hasImage) {
        result = await _scamAnalysisService.analyzeImage(
          image: _selectedImage!,
          message: message,
        );
      } else {
        result = await _scamAnalysisService.analyze(
          message: message,
        );
      }

      if (!mounted) {
        return;
      }

      final recommendation = _recommendationService.forScam(result);

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

  Future<Widget> _buildImagePreview() async {
    final bytes = await _selectedImage!.readAsBytes();

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Image.memory(
        bytes,
        height: 220,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Check Scam',
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
              'Is this a scam?',
              style: TextStyle(
                fontSize: 29,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
                height: 1.15,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Paste a suspicious message or upload a screenshot '
              'and Sentri will help you assess the risk.',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 24),

            // --------------------------------------------------
            // Message input
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
                  controller: _messageController,
                  enabled: !_isLoading,
                  maxLines: 6,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 15,
                    height: 1.45,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Suspicious message',
                    labelStyle: const TextStyle(
                      color: AppColors.textSecondary,
                    ),
                    hintText: 'Paste the message you received here...',
                    hintStyle: TextStyle(
                      color: AppColors.textSecondary.withOpacity(0.75),
                    ),
                    alignLabelWithHint: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // --------------------------------------------------
            // Screenshot section
            // --------------------------------------------------
            if (_selectedImage == null)
              _buildUploadCard()
            else
              _buildSelectedImageSection(),

            const SizedBox(height: 22),

            // --------------------------------------------------
            // Analyze button
            // --------------------------------------------------
            SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _analyzeScam,
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
                            'Analyze Message',
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
              ScamResultCard(
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

  Widget _buildUploadCard() {
    return InkWell(
      onTap: _isLoading ? null : _pickImage,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.18),
          ),
        ),
        child: const Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.white,
              child: Icon(
                Icons.image_outlined,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upload a screenshot',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Use a screenshot of the suspicious message.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedImageSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<Widget>(
            future: _buildImagePreview(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  height: 220,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                );
              }

              if (snapshot.hasError || !snapshot.hasData) {
                return Container(
                  height: 220,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.broken_image_outlined,
                    size: 42,
                    color: AppColors.textSecondary,
                  ),
                );
              }

              return snapshot.data!;
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isLoading ? null : _pickImage,
                  icon: const Icon(Icons.swap_horiz_rounded),
                  label: const Text('Change'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(
                      color: AppColors.border,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextButton.icon(
                  onPressed: _isLoading
                      ? null
                      : () {
                          setState(() {
                            _selectedImage = null;
                          });
                        },
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.highRisk,
                  ),
                  label: const Text(
                    'Remove',
                    style: TextStyle(
                      color: AppColors.highRisk,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 13,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
