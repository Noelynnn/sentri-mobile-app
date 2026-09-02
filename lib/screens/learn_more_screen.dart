import 'package:flutter/material.dart';

class LearnMoreScreen extends StatelessWidget {
  const LearnMoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Learn More"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(25),
          children: [
            Icon(
              Icons.shield_outlined,
              size: 75,
              color: Colors.indigo.shade900,
            ),
            const SizedBox(height: 25),
            Text(
              "About Sentri",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.indigo.shade900,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              "Sentri is your digital safety companion, designed to help you recognize and respond to online threats.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              "What Sentri can help you with",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.indigo.shade900,
              ),
            ),
            const SizedBox(height: 15),
            _buildFeature(
              icon: Icons.search,
              title: "Scam Detection",
              description:
                  "Analyze suspicious messages and identify possible scam indicators.",
            ),
            _buildFeature(
              icon: Icons.phishing_outlined,
              title: "Phishing Detection",
              description: "Check suspicious links for signs of phishing.",
            ),
            _buildFeature(
              icon: Icons.school_outlined,
              title: "Cybersecurity Learning",
              description: "Learn practical ways to protect yourself online.",
            ),
            _buildFeature(
              icon: Icons.report_outlined,
              title: "Cybercrime Reporting",
              description:
                  "Get guidance on reporting suspicious or harmful online activity.",
            ),
            const SizedBox(height: 30),
            Text(
              "Our goal",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.indigo.shade900,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Sentri aims to make digital safety easier to understand and easier to practise, especially when you're unsure whether something online can be trusted.",
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.indigo.shade900,
            size: 28,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
