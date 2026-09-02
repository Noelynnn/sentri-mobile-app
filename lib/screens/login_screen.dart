import 'package:flutter/material.dart';
import 'package:sentri/screens/forgot_password_screen.dart';
import 'package:sentri/screens/register_screen.dart';
import 'package:sentri/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 40),
              children: [
                // Sentri icon
                Icon(
                  Icons.shield_outlined,
                  color: Colors.indigo.shade900,
                  size: 80,
                ),

                const SizedBox(height: 20),

                // Title
                Text(
                  "Welcome Back",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo.shade900,
                  ),
                ),

                const SizedBox(height: 10),

                // Description
                Text(
                  "Login to continue protecting your digital life",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),

                const SizedBox(height: 40),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    }

                    if (!value.contains("@")) {
                      return "Enter a valid email";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 8),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordScreen(),
                              ),
                            );
                          },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.indigo.shade600,
                      overlayColor: Colors.indigo.shade100,
                    ),
                    child: const Text("Forgot Password?"),
                  ),
                ),

                const SizedBox(height: 20),

                // Login Button
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }

                          setState(() {
                            _isLoading = true;
                          });

                          await Future.delayed(
                            const Duration(seconds: 2),
                          );

                          if (!context.mounted) {
                            return;
                          }

                          final email = _emailController.text.trim();
                          final password = _passwordController.text;

                          const correctEmail = "test@sentri.com";
                          const correctPassword = "sentri123";

                          final isValidLogin = email == correctEmail &&
                              password == correctPassword;

                          if (!isValidLogin) {
                            setState(() {
                              _isLoading = false;
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Invalid email or password.",
                                ),
                              ),
                            );

                            return;
                          }

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(
                                userName: "Sentri User",
                              ),
                            ),
                          );
                        },
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Log In",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),

                const SizedBox(height: 20),

                // Sign Up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.indigo.shade600,
                        overlayColor: Colors.indigo.shade100,
                      ),
                      child: const Text("Sign Up"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
