import 'package:flutter/material.dart';
import '../../domain/entities/app_version_entity.dart';
import '../../domain/usecases/get_app_version_usecase.dart';

class AppVersionProvider extends ChangeNotifier {
  final GetAppVersionUseCase getAppVersionUseCase;

  AppVersionProvider({required this.getAppVersionUseCase});

  AppVersionEntity? _appVersion;
  bool _isLoading = false;
  String? _errorMessage;

  AppVersionEntity? get appVersion => _appVersion;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchAppVersion({
    required int roleId,
    required String device,
    required String versionNumber,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getAppVersionUseCase(
      roleId: roleId,
      device: device,
      versionNumber: versionNumber,
    );

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (data) {
        _appVersion = data;
        _isLoading = false;
        notifyListeners();
      },
    );
  }
}
