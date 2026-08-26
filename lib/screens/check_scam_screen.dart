import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/analysis_result.dart';
import '../widgets/scam_result_card.dart';

class CheckScamScreen extends StatefulWidget {
  const CheckScamScreen({super.key});

  @override
  State<CheckScamScreen> createState() => _CheckScamScreenState();
}

class _CheckScamScreenState extends State<CheckScamScreen> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  bool _isLoading = false;
  AnalysisResult? _analysisResult;
  XFile? _selectedImage;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (!context.mounted) return;

    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Check Scam"),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              "Is this a scam?",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.indigo.shade900,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Paste a suspicious message below or upload a screenshot and Sentri will help you assess it.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 30),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _messageController,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: "Suspicious message",
                  hintText: "Paste the message you received here...",
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            if (_selectedImage == null) ...[
              OutlinedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image_outlined),
                label: const Text("Upload Screenshot"),
              ),
            ] else ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(_selectedImage!.path),
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.swap_horiz),
                    label: const Text("Change"),
                  ),
                  const SizedBox(width: 12),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedImage = null;
                      });
                    },
                    icon: const Icon(Icons.delete_outline),
                    label: const Text("Remove"),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () async {
                      final message = _messageController.text.trim();
                      final hasMessage = message.isNotEmpty;
                      final hasImage = _selectedImage != null;

                      if (!hasMessage && !hasImage) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Enter a message or upload a screenshot to analyze.",
                            ),
                          ),
                        );
                        return;
                      }

                      setState(() {
                        _isLoading = false;

                        _analysisResult = const AnalysisResult(
                          riskLevel: "HIGH RISK",
                          message:
                              "This message shows signs of a potential scam.",
                          recommendation:
                              "Do not click any links or share personal information.",
                        );
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
                  : const Text("Analyze"),
            ),
            if (_analysisResult != null) ...[
              const SizedBox(height: 30),
              Text(
                "Analysis Result",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo.shade900,
                ),
              ),
              const SizedBox(height: 10),
              if (_analysisResult != null) ...[
                const SizedBox(height: 30),
                ScamResultCard(
                  result: _analysisResult!,
                ),
              ],
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}
