import 'dart:async';

import 'package:flutter/material.dart';

import 'package:sentri/screens/welcome_screen.dart';
import 'package:sentri/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _introController;
  late final AnimationController _pulseController;

  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<Offset> _slideAnimation;

  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    _introController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1400,
      ),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 2200,
      ),
    )..repeat(reverse: true);

    _fadeAnimation = CurvedAnimation(
      parent: _introController,
      curve: Curves.easeOut,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.82,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _introController,
        curve: Curves.easeOutBack,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _introController,
        curve: Curves.easeOutCubic,
      ),
    );

    _introController.forward();

    _navigationTimer = Timer(
      const Duration(
        milliseconds: 5000,
      ),
      _openWelcome,
    );
  }

  void _openWelcome() {
    if (!mounted) {
      return;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 550),
        reverseTransitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (
          context,
          animation,
          secondaryAnimation,
        ) =>
            const WelcomeScreen(),
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
  void dispose() {
    _navigationTimer?.cancel();
    _introController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Widget _buildAnimatedGlow({
    required Alignment alignment,
    required double size,
    required double opacity,
  }) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final movement = (_pulseController.value - 0.5) * 35;

        return Align(
          alignment: alignment,
          child: Transform.translate(
            offset: Offset(
              movement,
              -movement * 0.7,
            ),
            child: Opacity(
              opacity: opacity,
              child: Container(
                width: size,
                height: size,
                decoration: const BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
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
          _buildAnimatedGlow(
            alignment: const Alignment(
              -1.2,
              -0.85,
            ),
            size: 230,
            opacity: 0.055,
          ),
          _buildAnimatedGlow(
            alignment: const Alignment(
              1.15,
              0.7,
            ),
            size: 260,
            opacity: 0.045,
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                ),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: Container(
                            width: 116,
                            height: 116,
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(
                                0.10,
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.white.withOpacity(
                                  0.18,
                                ),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.white.withOpacity(
                                    0.10,
                                  ),
                                  blurRadius: 34,
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.shield_outlined,
                              color: AppColors.white,
                              size: 62,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 26,
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
                          height: 10,
                        ),
                        Text(
                          'Your Digital Safety Companion',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.white.withOpacity(
                              0.78,
                            ),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        SizedBox(
                          width: 150,
                          child: LinearProgressIndicator(
                            minHeight: 3,
                            backgroundColor: AppColors.white.withOpacity(
                              0.12,
                            ),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.white,
                            ),
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          'Securing your digital space...',
                          style: TextStyle(
                            color: AppColors.white.withOpacity(
                              0.58,
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
          ),
        ],
      ),
    );
  }
}
