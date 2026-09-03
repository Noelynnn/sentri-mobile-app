import 'package:flutter/material.dart';

import '../models/security_lesson.dart';

class SecurityLessonScreen extends StatelessWidget {
  final SecurityLesson lesson;

  const SecurityLessonScreen({
    super.key,
    required this.lesson,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Lesson icon
            Icon(
              lesson.icon,
              size: 70,
              color: Colors.indigo.shade900,
            ),

            const SizedBox(height: 20),

            // Lesson title
            Text(
              lesson.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.indigo.shade900,
              ),
            ),

            const SizedBox(height: 10),

            // Lesson description
            Text(
              lesson.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.grey.shade700,
              ),
            ),

            const SizedBox(height: 30),

            // Lesson sections
            ...lesson.sections.map(
              (section) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  section,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Safety tips heading
            Text(
              "Safety Tips",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.indigo.shade900,
              ),
            ),

            const SizedBox(height: 15),

            // Safety tips
            ...lesson.tips.map(
              (tip) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 22,
                      color: Colors.indigo.shade700,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        tip,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
