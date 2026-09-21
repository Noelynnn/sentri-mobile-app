import 'dart:typed_data';

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
  const CheckScamScreen({
    super.key,
  });

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
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 85,
    );

    if (!mounted || image == null) {
      return;
    }

    setState(() {
      _selectedImage = image;
      _analysisResult = null;
      _recommendation = null;
    });
  }

  Future<void> _analyzeScam() async {
    FocusScope.of(context).unfocus();

    final message = _messageController.text.trim();

    final hasMessage = message.isNotEmpty;
    final hasImage = _selectedImage != null;

    if (!hasMessage && !hasImage) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Enter a message or upload a screenshot first.',
          ),
        ),
      );

      return;
    }

    setState(() {
      _isLoading = true;
      _analysisResult = null;
      _recommendation = null;
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

      final recommendation = _recommendationService.forScam(
        result,
        sourceText: message,
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
      _messageController.clear();
      _selectedImage = null;
      _analysisResult = null;
      _recommendation = null;
    });
  }

  Future<Uint8List> _readImageBytes() async {
    return _selectedImage!.readAsBytes();
  }

  Widget _buildUploadCard() {
    return Material(
      color: AppColors.primaryLight,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: _isLoading ? null : _pickImage,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.16),
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
                      'Add a screenshot',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Optional — use a screenshot of the message.',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
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
          ClipRRect(
            borderRadius: BorderRadius.circular(17),
            child: FutureBuilder<Uint8List>(
              future: _readImageBytes(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: 220,
                    width: double.infinity,
                    color: AppColors.background,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  );
                }

                if (snapshot.hasError || snapshot.data == null) {
                  return Container(
                    height: 220,
                    width: double.infinity,
                    color: AppColors.background,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.broken_image_outlined,
                      size: 42,
                      color: AppColors.textSecondary,
                    ),
                  );
                }

                return Image.memory(
                  snapshot.data!,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isLoading ? null : _pickImage,
                  icon: const Icon(
                    Icons.swap_horiz_rounded,
                  ),
                  label: const Text('Change'),
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
                            _analysisResult = null;
                            _recommendation = null;
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
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
          ScamResultCard(
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
                'Check another message',
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
              'Is this a scam?',
              style: TextStyle(
                fontSize: 29,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
                height: 1.15,
              ),
            ),

            const SizedBox(height: 9),

            const Text(
              'Paste a suspicious message or add a screenshot. '
              'Sentri will assess the risk and explain what it found.',
              style: TextStyle(
                fontSize: 15.5,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 24),

            // --------------------------------------------------
            // Message
            // --------------------------------------------------
            const Text(
              'Message',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),

            const SizedBox(height: 10),

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
                  textCapitalization: TextCapitalization.sentences,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 15,
                    height: 1.45,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Suspicious message',
                    hintText: 'Paste the message you received here...',
                    labelStyle: const TextStyle(
                      color: AppColors.textSecondary,
                    ),
                    hintStyle: TextStyle(
                      color: AppColors.textSecondary.withOpacity(0.75),
                    ),
                    alignLabelWithHint: true,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // --------------------------------------------------
            // Screenshot
            // --------------------------------------------------
            if (_selectedImage == null)
              _buildUploadCard()
            else
              _buildSelectedImageSection(),

            const SizedBox(height: 20),

            // --------------------------------------------------
            // Scan button
            // --------------------------------------------------
            SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _analyzeScam,
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
                            Icons.radar_rounded,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Check for Scam',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 18),

            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.shield_outlined,
                  size: 18,
                  color: AppColors.primary,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Sentri provides an assessment to help you make a safer decision. '
                    'Do not share passwords, PINs, OTPs, or other sensitive information.',
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.45,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
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
