import 'package:flutter/material.dart';

import 'onboarding_screen.dart';
import 'register_screen.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({
    super.key,
  });

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();

  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage >= 2) {
      _finishOnboarding();
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
    );
  }

  void _previousPage() {
    if (_currentPage == 0) {
      return;
    }

    _pageController.previousPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  void _finishOnboarding() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (
          context,
          animation,
          secondaryAnimation,
        ) =>
            const RegisterScreen(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        allowImplicitScrolling: true,
        onPageChanged: (index) {
          if (!mounted) {
            return;
          }

          setState(() {
            _currentPage = index;
          });
        },
        children: [
          OnboardingScreen(
            title: 'Detect Scams Instantly',
            description:
                'Use AI to identify suspicious messages, fake websites, and phishing attempts before they can harm you.',
            icon: Icons.shield_outlined,
            buttonText: 'Next',
            currentPage: _currentPage + 1,
            onPressed: _nextPage,
            onSkip: _finishOnboarding,
          ),
          OnboardingScreen(
            title: 'Stay One Step Ahead',
            description:
                'Receive smart alerts and practical tips to recognize online threats before they reach you.',
            icon: Icons.security_rounded,
            buttonText: 'Next',
            currentPage: _currentPage + 1,
            onPressed: _nextPage,
            onBack: _previousPage,
            onSkip: _finishOnboarding,
          ),
          OnboardingScreen(
            title: 'Your Digital Safety Companion',
            description:
                'Let\'s work together to make your online experience safer, smarter, and more secure.',
            icon: Icons.verified_user_outlined,
            buttonText: 'Sign Up to Get Started',
            currentPage: _currentPage + 1,
            onPressed: _finishOnboarding,
            onBack: _previousPage,
          ),
        ],
      ),
    );
  }
}
