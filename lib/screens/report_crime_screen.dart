import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

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

  void _removeEvidence(int index) {
    if (_isLoading) {
      return;
    }

    setState(() {
      _evidenceImages.removeAt(index);
    });
  }

  Future<void> _submitReport() async {
    FocusScope.of(context).unfocus();

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
        evidence: List<XFile>.from(
          _evidenceImages,
        ),
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
          behavior: SnackBarBehavior.floating,
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

  Future<void> _openOfficialReportPage() async {
    final uri = Uri.parse(
      'https://ke-cirt.go.ke/report-an-incident/',
    );

    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Unable to open the KE-CIRT/CC reporting page. '
            'Please try again or use the contact details below.',
          ),
        ),
      );
    }
  }

  Future<void> _contactKeCirt() async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'incidents@ke-cirt.go.ke',
      queryParameters: {
        'subject': 'Cybercrime incident report',
      },
    );

    final launched = await launchUrl(uri);

    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Unable to open your email app. '
            'You can contact KE-CIRT/CC at incidents@ke-cirt.go.ke.',
          ),
        ),
      );
    }
  }

  void _startAnotherReport() {
    setState(() {
      _selectedIncidentType = null;
      _submittedReport = null;
      _evidenceImages.clear();
    });

    _descriptionController.clear();
    _detailsController.clear();

    _formKey.currentState?.reset();

    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 300),
    );
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
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
              'Tell us what happened. Your report can '
              'help document suspicious activity and '
              'provide useful information for follow-up.',
              style: TextStyle(
                fontSize: 15.5,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 18),
            _buildInfoCard(),
            const SizedBox(height: 24),
            if (_submittedReport == null)
              _buildReportForm()
            else
              _buildSubmissionReceipt(
                _submittedReport!,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 11),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Before you submit',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Include clear, factual details and '
                  'attach screenshots when they help '
                  'explain what happened.',
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.4,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionLabel(
            'INCIDENT DETAILS',
          ),
          const SizedBox(height: 10),
          _buildIncidentTypeField(),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _descriptionController,
            label: 'What happened?',
            hint: 'Describe the incident and what you noticed...',
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
          const SizedBox(height: 22),
          _buildSectionLabel(
            'SUPPORTING EVIDENCE',
          ),
          const SizedBox(height: 10),
          _buildEvidenceSection(),
          const SizedBox(height: 22),
          _buildSectionLabel(
            'ADDITIONAL INFORMATION',
          ),
          const SizedBox(height: 10),
          _buildTextField(
            controller: _detailsController,
            label: 'Additional details',
            hint: 'Add anything else that may help explain the incident...',
            maxLines: 4,
            icon: Icons.notes_outlined,
          ),
          const SizedBox(height: 14),
          _buildPrivacyNote(),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitReport,
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
                        SizedBox(width: 8),
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
    );
  }

  Widget _buildSectionLabel(
    String title,
  ) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 12.5,
        fontWeight: FontWeight.w800,
        color: AppColors.textSecondary,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildIncidentTypeField() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
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
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        16,
        15,
        16,
        14,
      ),
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
          Row(
            children: [
              Icon(
                icon,
                color: AppColors.primary,
                size: 21,
              ),
              const SizedBox(width: 9),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: controller,
            enabled: !_isLoading,
            maxLines: maxLines,
            textCapitalization: TextCapitalization.sentences,
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 15,
              height: 1.45,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
            validator: validator,
          ),
        ],
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(
                    13,
                  ),
                ),
                child: const Icon(
                  Icons.photo_library_outlined,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Screenshots',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Attach up to 3 screenshots that may help explain the incident.',
                      style: TextStyle(
                        fontSize: 12.5,
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
            const SizedBox(height: 16),
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

                  return FutureBuilder<List<int>>(
                    future: image.readAsBytes(),
                    builder: (
                      context,
                      snapshot,
                    ) {
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
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary,
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
                            child: Image.memory(
                              Uint8List.fromList(snapshot.data!),
                              width: 92,
                              height: 92,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 5,
                            right: 5,
                            child: GestureDetector(
                              onTap: () => _removeEvidence(
                                index,
                              ),
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
            ),
          if (_evidenceImages.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(
                top: 9,
              ),
              child: Text(
                '${_evidenceImages.length}/$_maxEvidenceImages screenshots attached',
                style: const TextStyle(
                  fontSize: 11.5,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPrivacyNote() {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: AppColors.primary,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Only include information that is relevant to the incident. '
              'Avoid sharing unnecessary passwords, PINs, or other sensitive credentials.',
              style: TextStyle(
                fontSize: 11.5,
                height: 1.4,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmissionReceipt(
    Report report,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.safeBackground,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.safe.withOpacity(0.25),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.safe,
                  size: 54,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Report submitted to Sentri',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 7),
              const Text(
                'Your report has been recorded successfully. '
                'For official incident handling, you can submit the '
                'incident to the National KE-CIRT/CC.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.5,
                  height: 1.45,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 22),
              _buildReceiptRow(
                label: 'Reference',
                value: report.referenceNumber,
                icon: Icons.tag_outlined,
              ),
              const SizedBox(height: 13),
              _buildReceiptRow(
                label: 'Incident',
                value: report.incidentType,
                icon: Icons.report_outlined,
              ),
              const SizedBox(height: 13),
              _buildReceiptRow(
                label: 'Status',
                value: _formatStatus(
                  report.status,
                ),
                icon: Icons.radio_button_checked_outlined,
              ),
              const SizedBox(height: 13),
              _buildReceiptRow(
                label: 'Evidence',
                value: report.evidenceCount == 0
                    ? 'None attached'
                    : '${report.evidenceCount} screenshot'
                        '${report.evidenceCount == 1 ? '' : 's'} attached',
                icon: Icons.photo_library_outlined,
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.bookmark_outline,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Keep your Sentri reference number and your original evidence '
                        'for future follow-up.',
                        style: TextStyle(
                          fontSize: 12.5,
                          height: 1.4,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
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
                    Icons.account_balance_outlined,
                    color: AppColors.primary,
                    size: 22,
                  ),
                  SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      'Next step: official reporting',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Sentri has recorded your report, but this does not mean '
                'it has been filed with a government authority. '
                'For official incident reporting in Kenya, use the '
                'National KE-CIRT/CC reporting channel.',
                style: TextStyle(
                  fontSize: 12.5,
                  height: 1.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _openOfficialReportPage,
                  icon: const Icon(
                    Icons.open_in_new_rounded,
                    size: 19,
                  ),
                  label: const Text(
                    'Report to KE-CIRT/CC',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: OutlinedButton.icon(
                  onPressed: _contactKeCirt,
                  icon: const Icon(
                    Icons.email_outlined,
                    size: 19,
                  ),
                  label: const Text(
                    'Email KE-CIRT/CC',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'KE-CIRT/CC: incidents@ke-cirt.go.ke  •  '
                '+254 703 042700  •  +254 730 172700',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.5,
                  height: 1.45,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton.icon(
            onPressed: _startAnotherReport,
            icon: const Icon(
              Icons.add_rounded,
            ),
            label: const Text(
              'Report Another Incident',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReceiptRow({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: AppColors.primary,
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
        ),
      ],
    );
  }

  String _formatStatus(String status) {
    switch (status.toLowerCase()) {
      case 'submitted':
        return 'Submitted';

      case 'reviewed':
        return 'Reviewed';

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
