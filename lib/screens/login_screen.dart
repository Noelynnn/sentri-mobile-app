import 'package:flutter/material.dart';
import 'package:sentri/screens/forgot_password_screen.dart';
import 'register_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obsecurePassword = true;
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
                  Icon(
                    Icons.shield_outlined,
                    color: Colors.indigo.shade900,
                    size: 80,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
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
                  Text(
                    "Login to continue protecting your digital life",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                        fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 40),
                  //Email Field
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
                  //Password field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obsecurePassword,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_obsecurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                        onPressed: () {
                          setState(() {});
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
                  //Forgot password field
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: const Text("Forgot Password?"),
                    ),
                  ),
                  const SizedBox(height: 20),
                  //Login button
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });

                              await Future.delayed(const Duration(seconds: 2));

                              final email = _emailController.text;
                              final password = _passwordController.text;

                              if (email == "test@sentri.com" &&
                                  password == "sentri123") {
                                setState(() {
                                  _isLoading = false;
                                });

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomeScreen(),
                                  ),
                                );
                              } else {
                                setState(() {
                                  _isLoading = false;
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Invalid email or password."),
                                  ),
                                );
                              }
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
                        : const Text("Log In"),
                  ),
                  const SizedBox(height: 20),
                  //Sign up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: const Text("Sign Up"),
                      ),
                    ],
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
