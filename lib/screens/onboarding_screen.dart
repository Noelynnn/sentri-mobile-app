import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class OnboardingScreen extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final String buttonText;
  final int currentPage;
  final VoidCallback onPressed;
  final VoidCallback? onBack;
  final VoidCallback? onSkip;

  const OnboardingScreen({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.buttonText,
    required this.currentPage,
    required this.onPressed,
    this.onBack,
    this.onSkip,
  });

  Widget _buildIndicator({
    required bool active,
  }) {
    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 250,
      ),
      curve: Curves.easeOut,
      width: active ? 28 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: active
            ? AppColors.white
            : AppColors.white.withOpacity(
                0.28,
              ),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = currentPage == 3;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF101B4D),
              Color(0xFF1C2D72),
              Color(0xFF243B8A),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: -70,
                right: -80,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.035),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: -100,
                left: -90,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.025),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      8,
                      16,
                      0,
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 48,
                          height: 48,
                          child: onBack != null
                              ? IconButton(
                                  tooltip: 'Back',
                                  onPressed: onBack,
                                  icon: const Icon(
                                    Icons.arrow_back_rounded,
                                    color: AppColors.white,
                                  ),
                                )
                              : null,
                        ),
                        const Spacer(),
                        if (onSkip != null)
                          TextButton(
                            onPressed: onSkip,
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.white.withOpacity(
                                0.72,
                              ),
                            ),
                            child: const Text(
                              'Skip',
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(
                        26,
                        22,
                        26,
                        18,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 560,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 154,
                                height: 154,
                                decoration: BoxDecoration(
                                  color: AppColors.white.withOpacity(
                                    0.08,
                                  ),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.white.withOpacity(
                                      0.14,
                                    ),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.white.withOpacity(
                                        0.06,
                                      ),
                                      blurRadius: 35,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: Container(
                                  width: 112,
                                  height: 112,
                                  decoration: BoxDecoration(
                                    color: AppColors.white.withOpacity(
                                      0.10,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Icon(
                                    icon,
                                    color: AppColors.white,
                                    size: 60,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 36,
                              ),
                              Text(
                                title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 29,
                                  height: 1.15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(
                                height: 17,
                              ),
                              Text(
                                description,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.white.withOpacity(
                                    0.78,
                                  ),
                                  fontSize: 16,
                                  height: 1.55,
                                ),
                              ),
                              const SizedBox(
                                height: 34,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildIndicator(
                                    active: currentPage == 1,
                                  ),
                                  const SizedBox(
                                    width: 7,
                                  ),
                                  _buildIndicator(
                                    active: currentPage == 2,
                                  ),
                                  const SizedBox(
                                    width: 7,
                                  ),
                                  _buildIndicator(
                                    active: currentPage == 3,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                '$currentPage of 3',
                                style: TextStyle(
                                  color: AppColors.white.withOpacity(
                                    0.45,
                                  ),
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      24,
                      4,
                      24,
                      24,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 560,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: onPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.white,
                            foregroundColor: AppColors.primary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                16,
                              ),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(buttonText),
                              const SizedBox(
                                width: 8,
                              ),
                              Icon(
                                isLastPage
                                    ? Icons.arrow_forward_rounded
                                    : Icons.arrow_forward_rounded,
                                size: 19,
                              ),
                            ],
                          ),
                        ),
                      ),
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
}
