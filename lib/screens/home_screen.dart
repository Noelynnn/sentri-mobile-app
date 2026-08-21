import 'package:flutter/material.dart';
import '../widgets/quick_action_card.dart';
import '../widgets/security_status_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      color: Colors.indigo.shade900,
                      size: 35,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Sentri",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo.shade900,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    // Notifications will be implemented later.
                  },
                  icon: const Icon(Icons.notifications_outlined),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              "Good morning! 👋",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.indigo.shade900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Here's your digital safety overview.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
