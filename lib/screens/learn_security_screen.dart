import 'package:flutter/material.dart';
import '../widgets/security_topic_card.dart';

class LearnSecurityScreen extends StatelessWidget {
  const LearnSecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Learn Security"),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              "Stay Safe Online",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.indigo.shade900,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Explore simple lessons that can help you recognize and avoid online threats.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 30),
            SecurityTopicCard(
              icon: Icons.lock_outline,
              title: "Password Safety",
              description: "Learn how to create and protect strong passwords.",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Password Safety lesson coming soon."),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            SecurityTopicCard(
              icon: Icons.phishing_outlined,
              title: "Phishing Awareness",
              description:
                  "Learn how to recognize suspicious messages and links.",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Phishing Awareness lesson coming soon.",
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            SecurityTopicCard(
              icon: Icons.warning_amber_outlined,
              title: "Online Scams",
              description: "Understand common scams and how to avoid them.",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Online Scams lesson coming soon."),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            SecurityTopicCard(
              icon: Icons.psychology_outlined,
              title: "Social Engineering",
              description:
                  "Learn how attackers manipulate people into giving up information.",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Social Engineering lesson coming soon.",
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            SecurityTopicCard(
              icon: Icons.language_outlined,
              title: "Safe Browsing",
              description:
                  "Learn safer habits for browsing and using websites.",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Safe Browsing lesson coming soon."),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
