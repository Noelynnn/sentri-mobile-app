import 'package:flutter/material.dart';

class ReportCrimeScreen extends StatefulWidget {
  const ReportCrimeScreen({super.key});

  @override
  State<ReportCrimeScreen> createState() => _ReportCrimeScreenState();
}

class _ReportCrimeScreenState extends State<ReportCrimeScreen> {
  final _formKey = GlobalKey<FormState>();

  final _descriptionController = TextEditingController();
  final _detailsController = TextEditingController();

  String? _selectedIncidentType;
  bool _isLoading = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Report Crime"),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    "Report a Cybercrime",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo.shade900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Provide details about a scam, phishing attempt, or other cybercrime.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 30),
                  DropdownButtonFormField<String>(
                    value: _selectedIncidentType,
                    decoration: const InputDecoration(
                      labelText: "Incident Type",
                      prefixIcon: Icon(Icons.category_outlined),
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "Scam",
                        child: Text("Scam"),
                      ),
                      DropdownMenuItem(
                        value: "Phishing",
                        child: Text("Phishing"),
                      ),
                      DropdownMenuItem(
                        value: "Identity Theft",
                        child: Text("Identity Theft"),
                      ),
                      DropdownMenuItem(
                        value: "Other",
                        child: Text("Other"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedIncidentType = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please select an incident type";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      hintText: "Describe what happened...",
                      alignLabelWithHint: true,
                      prefixIcon: Icon(Icons.description_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please describe the incident";
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _detailsController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: "Additional Details (Optional)",
                      hintText: "Add any other information that may help...",
                      alignLabelWithHint: true,
                      prefixIcon: Icon(Icons.notes_outlined),
                      border: OutlineInputBorder(),
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
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Report submitted successfully!"),
                              ),
                            );
                          },
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text("Submit Report"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
