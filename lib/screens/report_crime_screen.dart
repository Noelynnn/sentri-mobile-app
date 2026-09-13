import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/report.dart';
import '../services/auth_api_service.dart';
import '../services/report_api_service.dart';
import '../theme/app_colors.dart';

class ReportCrimeScreen extends StatefulWidget {
  const ReportCrimeScreen({
    super.key,
  });

  @override
  State<ReportCrimeScreen> createState() => _ReportCrimeScreenState();
}

class _ReportCrimeScreenState extends State<ReportCrimeScreen> {
  final _formKey = GlobalKey<FormState>();

  final _descriptionController = TextEditingController();

  final _detailsController = TextEditingController();

  final ReportApiService _reportApiService = ReportApiService();

  final ImagePicker _picker = ImagePicker();

  String? _selectedIncidentType;

  bool _isLoading = false;

  Report? _submittedReport;

  final List<XFile> _evidenceImages = [];

  static const int _maxEvidenceImages = 3;

  @override
  void dispose() {
    _descriptionController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _pickEvidence() async {
    if (_evidenceImages.length >= _maxEvidenceImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'You can attach up to 3 screenshots.',
          ),
        ),
      );

      return;
    }

    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (!mounted || image == null) {
      return;
    }

    setState(() {
      _evidenceImages.add(image);
    });
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedIncidentType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select an incident type.',
          ),
        ),
      );

      return;
    }

    setState(() {
      _isLoading = true;
      _submittedReport = null;
    });

    try {
      final report = await _reportApiService.submitReport(
        incidentType: _selectedIncidentType!,
        description: _descriptionController.text,
        additionalDetails: _detailsController.text,
        evidence: List<XFile>.from(_evidenceImages),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _submittedReport = report;
      });
    } on ApiException catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.highRisk,
          behavior: SnackBarBehavior.floating,
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Report Crime',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            32,
          ),
          children: [
            const Text(
              'Report a Cybercrime',
              style: TextStyle(
                fontSize: 29,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Provide details about a scam, phishing '
              'attempt, or other cybercrime. Screenshots '
              'can help provide useful evidence.',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildIncidentTypeField(),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _descriptionController,
                    label: 'What happened?',
                    hint: 'Describe what happened...',
                    maxLines: 6,
                    icon: Icons.description_outlined,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please describe the incident';
                      }

                      if (value.trim().length < 5) {
                        return 'Please provide more detail';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  _buildEvidenceSection(),
                  const SizedBox(height: 18),
                  _buildTextField(
                    controller: _detailsController,
                    label: 'Additional details',
                    hint: 'Add any other information that may help...',
                    maxLines: 4,
                    icon: Icons.notes_outlined,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitReport,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        disabledBackgroundColor:
                            AppColors.primary.withOpacity(0.45),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            16,
                          ),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 21,
                              width: 21,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.4,
                                color: AppColors.white,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.send_outlined,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'Submit Report',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
            if (_submittedReport != null) ...[
              const SizedBox(height: 28),
              _buildSubmissionReceipt(
                _submittedReport!,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIncidentTypeField() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedIncidentType,
        decoration: const InputDecoration(
          labelText: 'Incident type',
          prefixIcon: Icon(
            Icons.category_outlined,
            color: AppColors.primary,
          ),
          border: InputBorder.none,
        ),
        items: const [
          DropdownMenuItem(
            value: 'Scam',
            child: Text('Scam'),
          ),
          DropdownMenuItem(
            value: 'Phishing',
            child: Text('Phishing'),
          ),
          DropdownMenuItem(
            value: 'Identity Theft',
            child: Text(
              'Identity Theft',
            ),
          ),
          DropdownMenuItem(
            value: 'Other',
            child: Text('Other'),
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
            return 'Please select an incident type';
          }

          return null;
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required int maxLines,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: TextFormField(
        controller: controller,
        enabled: !_isLoading,
        maxLines: maxLines,
        style: const TextStyle(
          color: AppColors.textDark,
          fontSize: 15,
          height: 1.45,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          alignLabelWithHint: true,
          prefixIcon: Icon(
            icon,
            color: AppColors.primary,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildEvidenceSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.photo_library_outlined,
                color: AppColors.primary,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Supporting evidence',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Add up to 3 screenshots that may help explain the incident.',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_evidenceImages.isNotEmpty) ...[
            const SizedBox(height: 14),
            SizedBox(
              height: 92,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _evidenceImages.length,
                separatorBuilder: (_, __) => const SizedBox(
                  width: 10,
                ),
                itemBuilder: (context, index) {
                  final image = _evidenceImages[index];

                  return FutureBuilder<Widget>(
                    future: _buildEvidencePreview(
                      image,
                    ),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                          width: 92,
                          height: 92,
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(
                              14,
                            ),
                          ),
                        );
                      }

                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                              14,
                            ),
                            child: SizedBox(
                              width: 92,
                              height: 92,
                              child: snapshot.data!,
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: _isLoading
                                  ? null
                                  : () {
                                      setState(
                                        () {
                                          _evidenceImages.removeAt(
                                            index,
                                          );
                                        },
                                      );
                                    },
                              child: Container(
                                width: 26,
                                height: 26,
                                decoration: const BoxDecoration(
                                  color: AppColors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close_rounded,
                                  size: 17,
                                  color: AppColors.highRisk,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
          if (_evidenceImages.length < _maxEvidenceImages)
            OutlinedButton.icon(
              onPressed: _isLoading ? null : _pickEvidence,
              icon: const Icon(
                Icons.add_photo_alternate_outlined,
              ),
              label: Text(
                _evidenceImages.isEmpty ? 'Add screenshot' : 'Add another',
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(
                  color: AppColors.border,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    14,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<Widget> _buildEvidencePreview(
    XFile image,
  ) async {
    final bytes = await image.readAsBytes();

    return Image.memory(
      bytes,
      fit: BoxFit.cover,
    );
  }

  Widget _buildSubmissionReceipt(
    Report report,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.safeBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.safe.withOpacity(
            0.25,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.check_circle_outline,
                color: AppColors.safe,
                size: 30,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Report submitted successfully',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'Your report has been recorded for follow-up.',
            style: TextStyle(
              fontSize: 14,
              height: 1.45,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 18),
          _buildReceiptRow(
            'Reference',
            report.referenceNumber,
            Icons.tag_outlined,
          ),
          const SizedBox(height: 12),
          _buildReceiptRow(
            'Status',
            _formatStatus(
              report.status,
            ),
            Icons.radio_button_checked_outlined,
          ),
          const SizedBox(height: 12),
          _buildReceiptRow(
            'Evidence',
            report.evidenceCount == 0
                ? 'No screenshots attached'
                : '${report.evidenceCount} screenshot'
                    '${report.evidenceCount == 1 ? '' : 's'} attached',
            Icons.photo_library_outlined,
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(
              13,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(
                14,
              ),
            ),
            child: const Text(
              'Keep your reference number for future follow-up.',
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptRow(
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 19,
          color: AppColors.primary,
        ),
        const SizedBox(width: 9),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
        ),
      ],
    );
  }

  String _formatStatus(
    String status,
  ) {
    switch (status.toLowerCase()) {
      case 'submitted':
        return 'Submitted';

      case 'under_review':
        return 'Under Review';

      case 'resolved':
        return 'Resolved';

      default:
        return status
            .replaceAll('_', ' ')
            .split(' ')
            .map(
              (word) => word.isEmpty
                  ? word
                  : '${word[0].toUpperCase()}'
                      '${word.substring(1)}',
            )
            .join(' ');
    }
  }
}
