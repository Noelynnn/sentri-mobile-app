import 'package:flutter/material.dart';

import '../services/auth_api_service.dart';
import '../services/auth_storage_service.dart';
import 'admin_dashboard_screen.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'splash_screen.dart';

class StartupGate extends StatefulWidget {
  const StartupGate({
    super.key,
  });

  @override
  State<StartupGate> createState() => _StartupGateState();
}

class _StartupGateState extends State<StartupGate> {
  final AuthStorageService _storageService = AuthStorageService();

  final AuthApiService _authApiService = AuthApiService();

  @override
  void initState() {
    super.initState();
    _determineStartScreen();
  }

  Future<void> _determineStartScreen() async {
    final token = await _storageService.getToken();
    final rememberMe = await _storageService.getRememberMe();
    final userName = await _storageService.getUserName();

    debugPrint(
      'SENTRI STARTUP: '
      'token=${token != null && token.isNotEmpty}, '
      'rememberMe=$rememberMe, '
      'userName=$userName',
    );

    if (!mounted) {
      return;
    }

    // --------------------------------------------------
    // First-time user
    // --------------------------------------------------
    if (userName == null || userName.trim().isEmpty) {
      _open(
        const SplashScreen(),
      );
      return;
    }

    // --------------------------------------------------
    // Returning user with Remember Me enabled
    // --------------------------------------------------
    if (rememberMe && token != null && token.isNotEmpty) {
      try {
        // Ask the backend for the current user so we
        // know their current role.
        final user = await _authApiService.getCurrentUser();

        if (!mounted) {
          return;
        }

        if (user.isAdmin) {
          _open(
            AdminDashboardScreen(
              user: user,
            ),
          );
        } else {
          _open(
            HomeScreen(
              userName: user.fullName,
            ),
          );
        }

        return;
      } on ApiException catch (e) {
        debugPrint(
          'SENTRI STARTUP: '
          'Could not restore session: ${e.message}',
        );

        if (!mounted) {
          return;
        }

        // If the saved token is no longer valid,
        // clear the saved session and require login.
        await _storageService.deleteToken();

        if (!mounted) {
          return;
        }

        _open(
          const LoginScreen(),
        );

        return;
      } catch (e) {
        debugPrint(
          'SENTRI STARTUP: '
          'Unexpected session error: $e',
        );

        if (!mounted) {
          return;
        }

        _open(
          const LoginScreen(),
        );

        return;
      }
    }

    // --------------------------------------------------
    // Returning user who needs to log in
    // --------------------------------------------------
    _open(
      const LoginScreen(),
    );
  }

  void _open(Widget screen) {
    if (!mounted) {
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF7F8FC),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
