import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/analysis_result.dart';
import '../widgets/scam_result_card.dart';
import '../services/auth_api_service.dart';
import '../services/scam_analysis_service.dart';

class CheckScamScreen extends StatefulWidget {
  const CheckScamScreen({super.key});

  @override
  State<CheckScamScreen> createState() => _CheckScamScreenState();
}

class _CheckScamScreenState extends State<CheckScamScreen> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  final ScamAnalysisService _scamAnalysisService = ScamAnalysisService();

  final ImagePicker _picker = ImagePicker();

  bool _isLoading = false;
  XFile? _selectedImage;
  AnalysisResult? _analysisResult;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  // Picks an image from the device gallery.
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (!context.mounted) {
      return;
    }

    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  // Handles the scam analysis.
  Future<void> _analyzeScam() async {
    final message = _messageController.text.trim();

    final hasMessage = message.isNotEmpty;
    final hasImage = _selectedImage != null;

    if (!hasMessage && !hasImage) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a message or upload a screenshot.',
          ),
        ),
      );

      return;
    }

    setState(() {
      _isLoading = true;
      _analysisResult = null;
    });

    try {
      late final AnalysisResult result;

      if (hasImage) {
        result = await _scamAnalysisService.analyzeImage(
          image: _selectedImage!,
          message: message,
        );
      } else {
        result = await _scamAnalysisService.analyze(
          message: message,
        );
      }

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
        title: const Text("Check Scam"),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Title
            Text(
              "Is this a scam?",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.indigo.shade900,
              ),
            ),

            const SizedBox(height: 10),

            // Description
            Text(
              "Paste a suspicious message below or upload a screenshot and Sentri will help you assess it.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 30),

            // Message form
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

            const SizedBox(height: 20),

            // Screenshot section
            if (_selectedImage == null) ...[
              OutlinedButton.icon(
                onPressed: _isLoading ? null : _pickImage,
                icon: const Icon(Icons.image_outlined),
                label: const Text("Upload Screenshot"),
              ),
            ] else ...[
              // Screenshot preview
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

              // Change / Remove buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton.icon(
                    onPressed: _isLoading ? null : _pickImage,
                    icon: const Icon(Icons.swap_horiz),
                    label: const Text("Change"),
                  ),
                  const SizedBox(width: 12),
                  TextButton.icon(
                    onPressed: _isLoading
                        ? null
                        : () {
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

            const SizedBox(height: 30),

            // Analyze button
            ElevatedButton(
              onPressed: _isLoading ? null : _analyzeScam,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text("Analyze"),
            ),

            // Analysis result
            if (_analysisResult != null) ...[
              const SizedBox(height: 30),
              ScamResultCard(
                result: _analysisResult!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
