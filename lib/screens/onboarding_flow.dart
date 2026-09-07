import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'onboarding_screen.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();

  int currentPage = 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _finishOnboarding() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            currentPage = index + 1;
          });
        },
        children: [
          OnboardingScreen(
            title: "Detect Scams Instantly",
            description:
                "Use AI to identify suspicious messages, fake websites, and phishing attempts before they can harm you.",
            icon: Icons.shield_outlined,
            buttonText: "Next",
            currentPage: 1,
            onPressed: _nextPage,
          ),
          OnboardingScreen(
            title: "Stay One Step Ahead",
            description:
                "Receive smart alerts and practical tips to recognize online threats before they reach you.",
            icon: Icons.security,
            buttonText: "Next",
            currentPage: 2,
            onPressed: _nextPage,
          ),
          OnboardingScreen(
            title: "Your Digital Safety Companion",
            description:
                "Let's work together to make your online experience safer, smarter, and more secure.",
            icon: Icons.verified_user,
            buttonText: "Get Started",
            currentPage: 3,
            onPressed: _finishOnboarding,
          ),
        ],
      ),
    );
  }
}
