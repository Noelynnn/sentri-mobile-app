import 'package:flutter/material.dart';

import '../models/security_lesson.dart';
import '../widgets/security_topic_card.dart';
import 'security_lesson_screen.dart';

class LearnSecurityScreen extends StatelessWidget {
  const LearnSecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lessons = [
      const SecurityLesson(
        title: "Password Safety",
        description:
            "Learn how to create stronger passwords and protect your accounts.",
        icon: Icons.lock_outline,
        sections: [
          "A strong password is one of the simplest ways to protect an online account. Avoid using information that is easy to guess, such as your name, birthday, phone number, or common words.",
          "Use long, unique passwords for important accounts. Reusing the same password across multiple services can put several accounts at risk if one password is exposed.",
          "Where available, use a password manager to generate and store unique passwords rather than relying on memory.",
        ],
        tips: [
          "Use long and unique passwords.",
          "Avoid reusing the same password across important accounts.",
          "Never share your passwords with other people.",
          "Enable multi-factor authentication when available.",
        ],
      ),
      const SecurityLesson(
        title: "Phishing Awareness",
        description:
            "Learn how to recognize suspicious messages, websites, and links.",
        icon: Icons.phishing_outlined,
        sections: [
          "Phishing is a form of social engineering in which attackers try to trick people into revealing information, clicking malicious links, or taking an unsafe action.",
          "Phishing messages may pretend to come from banks, delivery services, schools, employers, social media platforms, or other trusted organizations.",
          "Attackers often create urgency or fear to make people act before they have time to verify the request.",
        ],
        tips: [
          "Check the sender before trusting a message.",
          "Be cautious with unexpected links and attachments.",
          "Do not enter sensitive information through links in suspicious messages.",
          "Verify unusual requests through an official channel.",
        ],
      ),
      const SecurityLesson(
        title: "Online Scams",
        description:
            "Understand common scam tactics and learn how to avoid them.",
        icon: Icons.warning_amber_outlined,
        sections: [
          "Online scams often rely on deception rather than technical hacking. Scammers may pretend that you have won something, owe money, received a package, or need to act immediately.",
          "A common warning sign is a request for money, passwords, verification codes, or other sensitive information that you were not expecting.",
          "Take a moment to verify the situation independently instead of acting under pressure.",
        ],
        tips: [
          "Be suspicious of unexpected requests for money.",
          "Do not share verification codes with anyone.",
          "Question offers that seem too good to be true.",
          "Take time to verify urgent requests.",
        ],
      ),
      const SecurityLesson(
        title: "Social Engineering",
        description:
            "Learn how attackers manipulate people into revealing information or taking unsafe actions.",
        icon: Icons.psychology_outlined,
        sections: [
          "Social engineering attacks target human behavior. Instead of trying to break into a system directly, an attacker may manipulate a person into giving them access or information.",
          "Attackers may use authority, urgency, fear, curiosity, or familiarity to gain trust.",
          "Recognizing these psychological tactics can help you slow down and make safer decisions.",
        ],
        tips: [
          "Be cautious when someone pressures you to act quickly.",
          "Verify identities before sharing sensitive information.",
          "Do not assume a familiar name or profile proves someone's identity.",
          "When something feels unusual, pause and verify it.",
        ],
      ),
      const SecurityLesson(
        title: "Safe Browsing",
        description:
            "Build safer habits when visiting websites and using online services.",
        icon: Icons.language_outlined,
        sections: [
          "Safe browsing starts with paying attention to where links lead and what information a website asks you to provide.",
          "Before entering sensitive information, check that you are using the intended website and that the connection is protected.",
          "Keep your browser and devices updated so that security fixes are applied regularly.",
        ],
        tips: [
          "Check website addresses before entering sensitive information.",
          "Avoid downloading files from untrusted sources.",
          "Keep your browser and device software updated.",
          "Use caution when browsing on public or unsecured networks.",
        ],
      ),
    ];

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
            ...lessons.map(
              (lesson) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SecurityTopicCard(
                  icon: lesson.icon,
                  title: lesson.title,
                  description: lesson.description,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SecurityLessonScreen(
                          lesson: lesson,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
