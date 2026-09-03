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
  String? _reportReference;

  @override
  void dispose() {
    _descriptionController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  // Generates a temporary report reference.
  // This will eventually come from the backend.
  String _generateReportReference() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    return "SR-${DateTime.now().year}-${timestamp.toString().substring(timestamp.toString().length - 4)}";
  }

  // Handles report submission.
  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _reportReference = null;
    });

    // Simulate report submission.
    await Future.delayed(
      const Duration(seconds: 2),
    );

    if (!context.mounted) {
      return;
    }

    setState(() {
      _isLoading = false;
      _reportReference = _generateReportReference();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Report Crime"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Title
            Text(
              "Report a Cybercrime",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.indigo.shade900,
              ),
            ),

            const SizedBox(height: 10),

            // Description
            Text(
              "Provide details about a scam, phishing attempt, or other cybercrime.",
              style: TextStyle(
                fontSize: 16,
                height: 1.4,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 30),

            // Report form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Incident Type
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
                    onChanged: _isLoading
                        ? null
                        : (value) {
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

                  // Description
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 6,
                    enabled: !_isLoading,
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

                  // Additional Details
                  TextFormField(
                    controller: _detailsController,
                    maxLines: 4,
                    enabled: !_isLoading,
                    decoration: const InputDecoration(
                      labelText: "Additional Details (Optional)",
                      hintText: "Add any other information that may help...",
                      alignLabelWithHint: true,
                      prefixIcon: Icon(Icons.notes_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Submit Report button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submitReport,
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
                            "Submit Report",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ],
              ),
            ),

            // Submission confirmation
            if (_reportReference != null) ...[
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.green.withOpacity(0.08),
                  border: Border.all(
                    color: Colors.green.withOpacity(0.35),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: Colors.green,
                          size: 30,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Report submitted successfully",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Your report has been recorded for follow-up.",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Reference Number",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo.shade900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _reportReference!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Keep this reference number for future follow-up.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
