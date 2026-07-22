import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../providers/profile_provider.dart';

class ProfilePage extends StatefulWidget {
  final int userAccountId;

  const ProfilePage({super.key, required this.userAccountId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  Uint8List? _pickedImageBytes;

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<ProfileProvider>();
      await provider.fetchProfile(widget.userAccountId);
      final profile = provider.profile;
      if (profile != null && mounted) {
        _userNameController.text = profile.userName;
        _emailController.text = profile.email;
        _contactController.text = profile.contact;
      }
    });
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (picked == null || !mounted) return;
    final bytes = await picked.readAsBytes();
    if (!mounted) return;
    setState(() => _pickedImageBytes = bytes);
  }

  Future<void> _saveProfile() async {
    final provider = context.read<ProfileProvider>();
    final success = await provider.saveProfile(
      userAccountId: widget.userAccountId,
      userName: _userNameController.text.trim(),
      email: _emailController.text.trim(),
      contact: _contactController.text.trim(),
      imageBytes: _pickedImageBytes,
    );
    if (!mounted) return;
    if (success) {
      setState(() => _pickedImageBytes = null);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    }
  }

  Future<void> _submitPasswordChange() async {
    final provider = context.read<ProfileProvider>();
    final success = await provider.changePassword(
      userAccountId: widget.userAccountId,
      currentPassword: _currentPasswordController.text,
      newPassword: _newPasswordController.text,
      confirmPassword: _confirmPasswordController.text,
    );
    if (!mounted) return;
    if (success) {
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('View Profile'),
        backgroundColor: AppColors.primaryNavy,
        foregroundColor: AppColors.white,
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.profile == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null && provider.profile == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      provider.errorMessage!,
                      style: const TextStyle(color: AppColors.errorText),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => provider.fetchProfile(widget.userAccountId),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final profile = provider.profile;
          if (profile == null) return const SizedBox.shrink();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _ProfileImageHeader(
                  imageUrl: profile.profileImageUrl,
                  pickedImageBytes: _pickedImageBytes,
                  onEditTap: _pickImage,
                ),
                const SizedBox(height: 24),
                _CardSection(
                  title: 'My Account',
                  children: [
                    _LabeledField(
                      icon: Icons.person_outline,
                      hintText: 'Username',
                      controller: _userNameController,
                    ),
                    const SizedBox(height: 16),
                    _LabeledField(
                      icon: Icons.email_outlined,
                      hintText: 'Email',
                      controller: _emailController,
                      readOnly: true,
                    ),
                    const SizedBox(height: 16),
                    _LabeledField(
                      icon: Icons.phone_outlined,
                      hintText: 'Mobile',
                      controller: _contactController,
                      readOnly: true,
                    ),
                    if (provider.saveError != null) ...[
                      const SizedBox(height: 16),
                      _InlineMessage(text: provider.saveError!, isError: true),
                    ],
                    const SizedBox(height: 20),
                    _SubmitButton(
                      label: 'Save Details',
                      isLoading: provider.isSaving,
                      onPressed: _saveProfile,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _CardSection(
                  title: 'Change Password',
                  children: [
                    _LabeledField(
                      icon: Icons.lock_outline,
                      hintText: 'Old Password',
                      controller: _currentPasswordController,
                      obscureText: _obscureCurrent,
                      onToggleObscure: () =>
                          setState(() => _obscureCurrent = !_obscureCurrent),
                    ),
                    const SizedBox(height: 16),
                    _LabeledField(
                      icon: Icons.lock_outline,
                      hintText: 'New Password',
                      controller: _newPasswordController,
                      obscureText: _obscureNew,
                      onToggleObscure: () => setState(() => _obscureNew = !_obscureNew),
                    ),
                    const SizedBox(height: 16),
                    _LabeledField(
                      icon: Icons.lock_outline,
                      hintText: 'Confirm Password',
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirm,
                      onToggleObscure: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                    if (provider.passwordError != null) ...[
                      const SizedBox(height: 16),
                      _InlineMessage(text: provider.passwordError!, isError: true),
                    ],
                    const SizedBox(height: 20),
                    _SubmitButton(
                      label: 'Submit',
                      isLoading: provider.isChangingPassword,
                      onPressed: _submitPasswordChange,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProfileImageHeader extends StatelessWidget {
  final String imageUrl;
  final Uint8List? pickedImageBytes;
  final VoidCallback onEditTap;

  const _ProfileImageHeader({
    required this.imageUrl,
    required this.pickedImageBytes,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipOval(
          child: pickedImageBytes != null
              ? Image.memory(pickedImageBytes!, width: 120, height: 120, fit: BoxFit.cover)
              : Image.network(
                  imageUrl,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 120,
                    height: 120,
                    color: AppColors.greyBorder,
                    child: const Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: onEditTap,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.primaryNavy,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.camera_alt, color: AppColors.white, size: 18),
            ),
          ),
        ),
      ],
    );
  }
}

class _CardSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _CardSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryNavy,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final TextEditingController controller;
  final bool readOnly;
  final bool obscureText;
  final VoidCallback? onToggleObscure;

  const _LabeledField({
    required this.icon,
    required this.hintText,
    required this.controller,
    this.readOnly = false,
    this.obscureText = false,
    this.onToggleObscure,
  });

  bool get _isPassword => onToggleObscure != null;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.grey, size: 20),
        suffixIcon: _isPassword
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: Colors.grey,
                  size: 20,
                ),
                onPressed: onToggleObscure,
              )
            : null,
        filled: true,
        fillColor: readOnly ? AppColors.background : AppColors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.greyBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.greyBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryNavy, width: 1),
        ),
      ),
    );
  }
}

class _InlineMessage extends StatelessWidget {
  final String text;
  final bool isError;

  const _InlineMessage({required this.text, required this.isError});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isError ? AppColors.errorBg : Colors.green.shade50,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isError ? AppColors.errorText : Colors.green.shade800,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onPressed;

  const _SubmitButton({
    required this.label,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryNavy,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2),
              )
            : Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
