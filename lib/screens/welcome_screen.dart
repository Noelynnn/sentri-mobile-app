import 'package:flutter/material.dart';

import 'learn_more_screen.dart';
import 'onboarding_flow.dart';
import '../theme/app_colors.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({
    super.key,
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 2600,
      ),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _openOnboarding() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
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

  Widget _buildGlow({
    required Alignment alignment,
    required double size,
  }) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final value = (_animationController.value - 0.5);

        return Align(
          alignment: alignment,
          child: Transform.translate(
            offset: Offset(
              value * 42,
              -value * 30,
            ),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(
                  0.045,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
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
          ),
          _buildGlow(
            alignment: const Alignment(
              -1.15,
              -0.8,
            ),
            size: 260,
          ),
          _buildGlow(
            alignment: const Alignment(
              1.1,
              0.8,
            ),
            size: 300,
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  28,
                  32,
                  28,
                  28,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 560,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(
                            0.10,
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.white.withOpacity(
                              0.18,
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.white.withOpacity(
                                0.08,
                              ),
                              blurRadius: 30,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.shield_outlined,
                          color: AppColors.white,
                          size: 52,
                        ),
                      ),
                      const SizedBox(
                        height: 28,
                      ),
                      Text(
                        'Welcome to',
                        style: TextStyle(
                          color: AppColors.white.withOpacity(
                            0.74,
                          ),
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      const Text(
                        'SENTRI',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 5,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Text(
                        'Stay one step ahead of scams, '
                        'phishing attempts, and online threats.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 17,
                          height: 1.55,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(
                            0.08,
                          ),
                          borderRadius: BorderRadius.circular(
                            30,
                          ),
                          border: Border.all(
                            color: AppColors.white.withOpacity(
                              0.10,
                            ),
                          ),
                        ),
                        child: const Text(
                          'Detect  •  Learn  •  Report',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 42,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _openOnboarding,
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
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          child: const Text(
                            'Get Started',
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LearnMoreScreen(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.white.withOpacity(
                            0.78,
                          ),
                        ),
                        child: const Text(
                          'Learn More',
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        'A safer way to navigate your digital world.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.white.withOpacity(
                            0.48,
                          ),
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
