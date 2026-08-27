import 'package:flutter/material.dart';

class PhishingCheckScreen extends StatefulWidget {
  const PhishingCheckScreen({super.key});

  @override
  State<PhishingCheckScreen> createState() => _PhishingCheckScreenState();
}

class _PhishingCheckScreenState extends State<PhishingCheckScreen> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();

  bool _isLoading = false;
  String? _analysisResult;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
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
            Text(
              "Check a suspicious link",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.indigo.shade900,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Paste a link below and Sentri will help you assess whether it may be a phishing link.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 30),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _urlController,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: "Suspicious link",
                  hintText: "https://example.com",
                  prefixIcon: Icon(Icons.link_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter a link";
                  }

                  if (!value.trim().startsWith("http://") &&
                      !value.trim().startsWith("https://")) {
                    return "Enter a valid URL";
                  }

                  return null;
                },
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () async {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }

                      setState(() {
                        _isLoading = true;
                      });

                      await Future.delayed(
                        const Duration(seconds: 2),
                      );

                      if (!context.mounted) return;

                      setState(() {
                        _isLoading = false;
                        _analysisResult = "Potential phishing link";
                      });
                    },
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Text("Analyze Link"),
            ),
            if (_analysisResult != null) ...[
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  _analysisResult!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
