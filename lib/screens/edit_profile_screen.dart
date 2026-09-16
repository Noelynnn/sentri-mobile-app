import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../config/api_config.dart';
import '../models/auth_response.dart';
import '../services/auth_api_service.dart';
import '../services/profile_api_service.dart';
import '../theme/app_colors.dart';

class EditProfileScreen extends StatefulWidget {
  final AuthUser user;

  const EditProfileScreen({
    super.key,
    required this.user,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();

  final _lastNameController = TextEditingController();

  final ProfileApiService _profileService = ProfileApiService();

  final ImagePicker _picker = ImagePicker();

  XFile? _selectedImage;

  bool _removeCurrentImage = false;
  bool _isSaving = false;

  late String? _currentImagePath;

  @override
  void initState() {
    super.initState();

    final nameParts = widget.user.fullName
        .trim()
        .split(' ')
        .where(
          (part) => part.isNotEmpty,
        )
        .toList();

    _firstNameController.text = nameParts.isNotEmpty ? nameParts.first : '';

    _lastNameController.text =
        nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    _currentImagePath = widget.user.profileImagePath;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  String? _imageUrl(String? path) {
    if (path == null || path.isEmpty) {
      return null;
    }

    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }

    return '${ApiConfig.baseUrl}/'
        '${path.replaceFirst('/', '')}';
  }

  Future<void> _pickImage() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (!mounted || image == null) {
      return;
    }

    setState(() {
      _selectedImage = image;
      _removeCurrentImage = false;
    });
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
      _removeCurrentImage = true;
      _currentImagePath = null;
    });
  }

  Future<void> _saveProfile() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final firstName = _firstNameController.text.trim();

    final lastName = _lastNameController.text.trim();

    final fullName = '$firstName $lastName'.trim();

    setState(() {
      _isSaving = true;
    });

    try {
      List<int>? imageBytes;
      String? imageFilename;

      if (_selectedImage != null) {
        imageBytes = await _selectedImage!.readAsBytes();

        imageFilename = _selectedImage!.name;
      }

      Map<String, dynamic> response = await _profileService.updateProfile(
        fullName: fullName,
        imageBytes: imageBytes,
        imageFilename: imageFilename,
      );

      AuthUser updatedUser = AuthUser.fromJson(response);

      if (_removeCurrentImage && _selectedImage == null) {
        final removedResponse = await _profileService.removeProfileImage();

        updatedUser = AuthUser.fromJson(
          removedResponse,
        );
      }

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Profile updated successfully.',
          ),
        ),
      );

      Navigator.pop(
        context,
        updatedUser,
      );
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
            'Unable to update your profile. Please try again.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Widget _buildInitials() {
    final first = _firstNameController.text.trim();

    final last = _lastNameController.text.trim();

    String initials = 'U';

    if (first.isNotEmpty && last.isNotEmpty) {
      initials = '${first[0]}${last[0]}'.toUpperCase();
    } else if (first.isNotEmpty) {
      initials = first[0].toUpperCase();
    }

    return Text(
      initials,
      style: const TextStyle(
        color: AppColors.white,
        fontSize: 32,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget _buildProfileImage() {
    if (_selectedImage != null) {
      return FutureBuilder<Uint8List>(
        future: _selectedImage!.readAsBytes(),
        builder: (
          context,
          snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 2.4,
                color: AppColors.white,
              ),
            );
          }

          if (!snapshot.hasData) {
            return _buildInitials();
          }

          return ClipOval(
            child: Image.memory(
              snapshot.data!,
              width: 112,
              height: 112,
              fit: BoxFit.cover,
            ),
          );
        },
      );
    }

    final imageUrl = _imageUrl(_currentImagePath);

    if (imageUrl != null && !_removeCurrentImage) {
      return ClipOval(
        child: Image.network(
          imageUrl,
          width: 112,
          height: 112,
          fit: BoxFit.cover,
          loadingBuilder: (
            context,
            child,
            loadingProgress,
          ) {
            if (loadingProgress == null) {
              return child;
            }

            return _buildInitials();
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildInitials();
          },
        ),
      );
    }

    return _buildInitials();
  }

  @override
  Widget build(BuildContext context) {
    final hasPhoto = _currentImagePath != null || _selectedImage != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Profile'),
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
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: AppColors.border,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 112,
                    height: 112,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: _buildProfileImage(),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Profile picture',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Choose a clear photo that represents you.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton.icon(
                    onPressed: _isSaving ? null : _pickImage,
                    icon: const Icon(
                      Icons.photo_camera_outlined,
                    ),
                    label: const Text(
                      'Change Photo',
                    ),
                  ),
                  if (hasPhoto) ...[
                    const SizedBox(height: 2),
                    TextButton(
                      onPressed: _isSaving ? null : _removeImage,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.highRisk,
                      ),
                      child: const Text(
                        'Remove Photo',
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: AppColors.border,
                ),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Personal Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Keep your Sentri account information up to date.',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _firstNameController,
                            enabled: !_isSaving,
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'First Name',
                              prefixIcon: Icon(
                                Icons.person_outline_rounded,
                                color: AppColors.primary,
                              ),
                            ),
                            validator: (value) {
                              final name = value?.trim() ?? '';

                              if (name.length < 2) {
                                return 'Required';
                              }

                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _lastNameController,
                            enabled: !_isSaving,
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Last Name',
                            ),
                            validator: (value) {
                              final name = value?.trim() ?? '';

                              if (name.length < 2) {
                                return 'Required';
                              }

                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: widget.user.email,
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Your email address is currently read-only.',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.35,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveProfile,
                child: _isSaving
                    ? const SizedBox(
                        width: 21,
                        height: 21,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          color: AppColors.white,
                        ),
                      )
                    : const Text(
                        'Save Changes',
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
