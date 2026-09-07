import 'package:flutter/material.dart';

class SecurityStatusCard extends StatelessWidget {
  final String status;

  const SecurityStatusCard({
    super.key,
    required this.status,
  });

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
          Text(
            status,
            style: const TextStyle(
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
        ],
      ),
    );
  }
}
