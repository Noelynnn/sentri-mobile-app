import 'package:flutter/material.dart';

import 'onboarding_flow.dart';
import '../theme/app_colors.dart';

class LearnMoreScreen extends StatelessWidget {
  const LearnMoreScreen({
    super.key,
  });

  void _startSentri(BuildContext context) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(
          milliseconds: 500,
        ),
        pageBuilder: (
          context,
          animation,
          secondaryAnimation,
        ) =>
            const OnboardingFlow(),
        transitionsBuilder: (
          context,
          animation,
          secondaryAnimation,
          child,
        ) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ),
            child: child,
          );
        },
      ),
    );
  }

  Widget _buildFeature({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.45,
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

  Widget _buildStep({
    required String number,
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.border,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: AppColors.primary,
                  size: 21,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
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
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMiniPill(
    IconData icon,
    String text,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15,
            color: AppColors.primary,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
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
          'Learn More',
        ),
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
            Container(
              padding: const EdgeInsets.fromLTRB(
                22,
                26,
                22,
                24,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF101B4D),
                    Color(0xFF243B8A),
                  ],
                ),
                borderRadius: BorderRadius.circular(26),
              ),
              child: Column(
                children: [
                  Container(
                    width: 78,
                    height: 78,
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(
                        0.10,
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.white.withOpacity(
                          0.15,
                        ),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.shield_outlined,
                      color: AppColors.white,
                      size: 42,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Meet Sentri',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 27,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your digital safety companion for checking, learning, and responding to online threats.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 14.5,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 7,
                    runSpacing: 7,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          'Detect',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          'Learn',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          'Report',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'What Sentri can help you with',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            _buildFeature(
              icon: Icons.search_rounded,
              title: 'Scam Detection',
              description:
                  'Analyze suspicious messages and screenshots for signs of scam activity.',
            ),
            const SizedBox(height: 10),
            _buildFeature(
              icon: Icons.phishing_outlined,
              title: 'Phishing Detection',
              description:
                  'Check suspicious links for characteristics commonly associated with phishing.',
            ),
            const SizedBox(height: 10),
            _buildFeature(
              icon: Icons.school_outlined,
              title: 'Cybersecurity Learning',
              description:
                  'Build practical digital safety skills through focused lessons and curated resources.',
            ),
            const SizedBox(height: 10),
            _buildFeature(
              icon: Icons.report_outlined,
              title: 'Cybercrime Reporting',
              description:
                  'Document suspicious incidents and keep track of the reports you submit.',
            ),
            const SizedBox(height: 28),
            const Text(
              'How Sentri works',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            _buildStep(
              number: '1',
              icon: Icons.radar_rounded,
              title: 'Check',
              description:
                  'Bring a suspicious message, screenshot, or link to Sentri.',
            ),
            const SizedBox(height: 10),
            _buildStep(
              number: '2',
              icon: Icons.analytics_outlined,
              title: 'Understand',
              description:
                  'See the detected risk level, reasons, and what the result means.',
            ),
            const SizedBox(height: 10),
            _buildStep(
              number: '3',
              icon: Icons.shield_outlined,
              title: 'Act safely',
              description:
                  'Use recommendations, learn the relevant topic, or report the incident when appropriate.',
            ),
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: AppColors.border,
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.favorite_border_rounded,
                    color: AppColors.primary,
                    size: 28,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Our goal',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    'Sentri aims to make digital safety easier to understand and easier to practise, especially when you are unsure whether something online can be trusted.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.5,
                      height: 1.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 7,
                    runSpacing: 7,
                    children: [
                      _buildMiniPill(
                        Icons.visibility_outlined,
                        'Awareness',
                      ),
                      _buildMiniPill(
                        Icons.school_outlined,
                        'Learning',
                      ),
                      _buildMiniPill(
                        Icons.shield_outlined,
                        'Protection',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              height: 52,
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _startSentri(context);
                },
                icon: const Icon(
                  Icons.arrow_forward_rounded,
                ),
                label: const Text(
                  'Explore Sentri',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
