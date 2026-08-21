import 'package:flutter/material.dart';
import '../widgets/quick_action_card.dart';

class SecurityStatusCard extends StatelessWidget {
  const SecurityStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.indigo.shade50,
      ),
      child: Column(
        children: [
          Icon(
            Icons.shield_outlined,
            size: 45,
            color: Colors.indigo.shade900,
          ),
          const SizedBox(height: 12),
          Text(
            "Security Status",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.indigo.shade900,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "You're Protected ✓",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "No immediate threats detected.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 25),
          const SecurityStatusCard(),
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Scam detection coming soon."),
                    ),
                  );
                },
              ),
              QuickActionCard(
                icon: Icons.school_outlined,
                title: "Learn Security",
                description: "Learn how to stay safe online.",
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Security learning coming soon."),
                    ),
                  );
                },
              ),
              QuickActionCard(
                icon: Icons.phishing_outlined,
                title: "Phishing Check",
                description: "Check suspicious links and messages.",
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Phishing detection coming soon."),
                    ),
                  );
                },
              ),
              QuickActionCard(
                icon: Icons.report_outlined,
                title: "Report Crime",
                description: "Report a cybercrime or scam.",
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Cybercrime reporting coming soon."),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
