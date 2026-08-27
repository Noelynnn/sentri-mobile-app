import 'package:flutter/material.dart';
import '../widgets/quick_action_card.dart';
import '../widgets/security_status_card.dart';
import 'check_scam_screen.dart';
import 'phishing_check_screen.dart';
import 'learn_security_screen.dart';
import 'report_crime_screen.dart';

class HomeScreen extends StatelessWidget {
  final String userName;
  const HomeScreen({super.key, required this.userName});

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
              "Good morning, $userName! 👋",
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
            const SizedBox(height: 25),
            const SecurityStatusCard(
              status: "You're Protected ✓",
            ),
            const SizedBox(height: 30),
            Text(
              "Quick Actions",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.indigo.shade900,
              ),
            ),
            const SizedBox(height: 15),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                QuickActionCard(
                  icon: Icons.search,
                  title: "Check Scam",
                  description: "Analyze a suspicious message.",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CheckScamScreen(),
                      ),
                    );
                  },
                ),
                QuickActionCard(
                  icon: Icons.school_outlined,
                  title: "Learn Security",
                  description: "Learn how to stay safe online.",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LearnSecurityScreen(),
                      ),
                    );
                  },
                ),
                QuickActionCard(
                  icon: Icons.phishing_outlined,
                  title: "Phishing Check",
                  description: "Check suspicious links and messages.",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PhishingCheckScreen(),
                      ),
                    );
                  },
                ),
                QuickActionCard(
                  icon: Icons.report_outlined,
                  title: "Report Crime",
                  description: "Report a cybercrime or scam.",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReportCrimeScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
