import 'package:flutter/material.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/entities/user_entity.dart';

class AuthProvider with ChangeNotifier {
  final LoginUseCase loginUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;

  AuthProvider(this.loginUseCase, this.forgotPasswordUseCase);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  UserEntity? _user;
  UserEntity? get user => _user;

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  bool _rememberMe = false;
  bool get rememberMe => _rememberMe;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleRememberMe(bool? value) {
    _rememberMe = value ?? false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await loginUseCase(email, password, rememberMe: _rememberMe);

    return result.fold(
      (failure) {
        _errorMessage = "Mobile number/Password is incorrect";
        _isLoading = false;
        notifyListeners();
        return false;
      },
      (user) {
        _user = user;
        _isLoading = false;
        notifyListeners();
        return true;
      },
    );
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  bool _isForgotPasswordLoading = false;
  bool get isForgotPasswordLoading => _isForgotPasswordLoading;

  String? _forgotPasswordMessage;
  String? get forgotPasswordMessage => _forgotPasswordMessage;

  bool _forgotPasswordSuccess = false;
  bool get forgotPasswordSuccess => _forgotPasswordSuccess;

  Future<void> submitForgotPassword(String contactNumber) async {
    _isForgotPasswordLoading = true;
    _forgotPasswordMessage = null;
    notifyListeners();

    final result = await forgotPasswordUseCase(contactNumber);

    result.fold(
      (failure) {
        _forgotPasswordSuccess = false;
        _forgotPasswordMessage = failure.message;
        _isForgotPasswordLoading = false;
        notifyListeners();
      },
      (message) {
        _forgotPasswordSuccess = true;
        _forgotPasswordMessage = message;
        _isForgotPasswordLoading = false;
        notifyListeners();
      },
    );
  }

  void resetForgotPasswordState() {
    _forgotPasswordMessage = null;
    _forgotPasswordSuccess = false;
    notifyListeners();
  }
}
