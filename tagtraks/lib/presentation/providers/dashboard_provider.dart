import 'package:flutter/material.dart';
import '../../domain/entities/dashboard_summary_entity.dart';
import '../../domain/entities/site_asset_entity.dart';
import '../../domain/usecases/get_dashboard_summary_usecase.dart';
import '../../domain/usecases/get_site_assets_usecase.dart';

class DashboardProvider with ChangeNotifier {
  final GetDashboardSummaryUseCase getDashboardSummaryUseCase;
  final GetSiteAssetsUseCase getSiteAssetsUseCase;

  DashboardProvider(this.getDashboardSummaryUseCase, this.getSiteAssetsUseCase);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  DashboardSummaryEntity? _summary;
  DashboardSummaryEntity? get summary => _summary;

  bool _isLoadingAssets = false;
  bool get isLoadingAssets => _isLoadingAssets;

  String? _assetsError;
  String? get assetsError => _assetsError;

  List<SiteAssetEntity> _siteAssets = [];
  List<SiteAssetEntity> get siteAssets => _siteAssets;

  Future<void> fetchDashboardSummary() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getDashboardSummaryUseCase();
    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (data) {
        _summary = data;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> fetchSiteAssets(int assetTypeId) async {
    _isLoadingAssets = true;
    _assetsError = null;
    notifyListeners();

    final result = await getSiteAssetsUseCase(assetTypeId);
    result.fold(
      (failure) {
        _assetsError = failure.message;
        _isLoadingAssets = false;
        notifyListeners();
      },
      (data) {
        _siteAssets = data;
        _isLoadingAssets = false;
        notifyListeners();
      },
    );
  }
}
