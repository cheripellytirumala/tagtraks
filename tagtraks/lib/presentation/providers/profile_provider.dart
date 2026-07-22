import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/usecases/change_password_usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';

class ProfileProvider with ChangeNotifier {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final ChangePasswordUseCase changePasswordUseCase;

  ProfileProvider(
    this.getProfileUseCase,
    this.updateProfileUseCase,
    this.changePasswordUseCase,
  );

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  ProfileEntity? _profile;
  ProfileEntity? get profile => _profile;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  String? _saveError;
  String? get saveError => _saveError;

  bool _isChangingPassword = false;
  bool get isChangingPassword => _isChangingPassword;

  String? _passwordError;
  String? get passwordError => _passwordError;

  Future<void> fetchProfile(int userAccountId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getProfileUseCase(userAccountId);
    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (data) {
        _profile = data;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<bool> saveProfile({
    required int userAccountId,
    required String userName,
    required String email,
    required String contact,
    Uint8List? imageBytes,
  }) async {
    _isSaving = true;
    _saveError = null;
    notifyListeners();

    final result = await updateProfileUseCase(
      userAccountId: userAccountId,
      userName: userName,
      email: email,
      contact: contact,
      profileImageBase64: imageBytes == null ? null : base64Encode(imageBytes),
    );

    return result.fold(
      (failure) {
        _saveError = failure.message;
        _isSaving = false;
        notifyListeners();
        return false;
      },
      (data) {
        _profile = data;
        _isSaving = false;
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> changePassword({
    required int userAccountId,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    _isChangingPassword = true;
    _passwordError = null;
    notifyListeners();

    final result = await changePasswordUseCase(
      userAccountId: userAccountId,
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );

    return result.fold(
      (failure) {
        _passwordError = failure.message;
        _isChangingPassword = false;
        notifyListeners();
        return false;
      },
      (_) {
        _isChangingPassword = false;
        notifyListeners();
        return true;
      },
    );
  }
}
