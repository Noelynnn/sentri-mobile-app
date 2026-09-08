import 'package:flutter/material.dart';

import '../models/analysis_result.dart';
import '../widgets/phishing_result_card.dart';
import '../services/auth_api_service.dart';
import '../services/phishing_analysis_service.dart';

class PhishingCheckScreen extends StatefulWidget {
  const PhishingCheckScreen({super.key});

  @override
  State<PhishingCheckScreen> createState() => _PhishingCheckScreenState();
}

class _PhishingCheckScreenState extends State<PhishingCheckScreen> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  final PhishingAnalysisService _phishingAnalysisService =
      PhishingAnalysisService();

  bool _isLoading = false;
  AnalysisResult? _analysisResult;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _analyzeLink() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _analysisResult = null;
    });

    try {
      final result = await _phishingAnalysisService.analyze(
        _urlController.text.trim(),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _analysisResult = result;
      });
    } on ApiException catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
        ),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Something went wrong. Please try again.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Phishing Check"),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Title
            Text(
              "Check a suspicious link",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.indigo.shade900,
              ),
            ),

            const SizedBox(height: 10),

            // Description
            Text(
              "Paste a link below and Sentri will help you assess whether it may be a phishing link.",
              style: TextStyle(
                fontSize: 16,
                height: 1.4,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 30),

            // URL form
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _urlController,
                keyboardType: TextInputType.url,
                enabled: !_isLoading,
                decoration: const InputDecoration(
                  labelText: "Suspicious link",
                  hintText: "https://example.com",
                  prefixIcon: Icon(Icons.link_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter a URL";
                  }

                  final uri = Uri.tryParse(value.trim());

                  if (uri == null ||
                      (uri.scheme != 'http' && uri.scheme != 'https') ||
                      uri.host.isEmpty) {
                    return "Enter a valid URL";
                  }

                  return null;
                },
              ),
            ),

            const SizedBox(height: 30),

            // Analyze button
            ElevatedButton(
              onPressed: _isLoading ? null : _analyzeLink,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      "Analyze Link",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),

            // Result
            if (_analysisResult != null) ...[
              const SizedBox(height: 30),
              PhishingResultCard(
                result: _analysisResult!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
