import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final String buttonText;
  final int currentPage;
  final VoidCallback onPressed;

  const OnboardingScreen({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.buttonText,
    required this.currentPage,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade900,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 100,
                ),
                const SizedBox(height: 40),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                          color:
                              currentPage == 1 ? Colors.white : Colors.white38,
                          shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                          color:
                              currentPage == 2 ? Colors.white : Colors.white38,
                          shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: currentPage == 3 ? Colors.white : Colors.white38,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(buttonText),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
