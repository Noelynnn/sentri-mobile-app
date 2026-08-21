import 'package:flutter/material.dart';
import 'package:sentri/screens/login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                  "Forgot Password?",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo.shade900,
                  ),
                ),

                const SizedBox(height: 10),

                // Description
                Text(
                  "Enter your email and we'll help you reset your password.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ),

                const SizedBox(height: 40),

                // Email field
                TextFormField(
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

                const SizedBox(height: 30),

                // Send reset link button
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });

                            await Future.delayed(const Duration(seconds: 2));

                            setState(() {
                              _isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Reset link sent successfully!"),
                              ),
                            );
                          }
                        },
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text("Send Reset Link"),
                ),

                const SizedBox(height: 20),

                // Back to Login
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text("Back to Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
